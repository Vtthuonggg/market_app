// lib/main_screen.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

const String MULTICAST_GROUP = '239.255.0.1';
const int PORT = 12345;

class MainScreen extends StatefulWidget {
  static const path = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  RawDatagramSocket? _socket;
  IOSink? _fileSink;
  File? _videoFile;
  VideoPlayerController? _controller;
  bool _isReceiving = false;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _startUdpListener();
  }

  @override
  void dispose() {
    _socket?.close();
    _fileSink?.close();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _startUdpListener() async {
    try {
      // Khởi tạo và kết nối UDP socket
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, PORT);

      // Tham gia vào nhóm multicast
      _socket?.joinMulticast(InternetAddress(MULTICAST_GROUP));

      // Tạo tệp tạm để lưu dữ liệu video
      Directory tempDir = await getTemporaryDirectory();
      String filePath = '${tempDir.path}/temp_video.mp4';
      _videoFile = File(filePath);

      // Nếu tệp đã tồn tại, xóa và tạo lại
      if (await _videoFile!.exists()) {
        await _videoFile!.delete();
      }
      await _videoFile!.create();

      // Mở file sink để ghi dữ liệu vào tệp
      _fileSink = _videoFile!.openWrite(mode: FileMode.writeOnlyAppend);

      // Lắng nghe các datagram từ UDP
      _socket?.listen((event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = _socket?.receive();
          if (dg != null) {
            Uint8List data = dg.data;
            _fileSink?.add(data);
            _fileSink?.flush();

            // Nếu controller chưa được khởi tạo và có dữ liệu thì khởi tạo
            if (!_isControllerInitialized &&
                _videoFile != null &&
                _videoFile!.lengthSync() > 0) {
              _initializeVideoPlayer();
            }
          }
        }
      });

      setState(() {
        _isReceiving = true;
      });
    } catch (e) {
      print('Error binding UDP socket: $e');
    }
  }

  Future<void> _initializeVideoPlayer() async {
    if (_videoFile == null) return;

    _controller = VideoPlayerController.file(_videoFile!)
      ..initialize().then((_) {
        setState(() {
          _isControllerInitialized = true;
        });
        _controller?.play();
      }).catchError((error) {
        print('Error initializing video player: $error');
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bate TV - Xem stream mọi lúc'),
      ),
      body: Center(
        child: _isControllerInitialized && _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : _isReceiving
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Đang nhận dữ liệu video...'),
                    ],
                  )
                : Text('Đang chờ dữ liệu video...'),
      ),
      floatingActionButton: _isControllerInitialized &&
              _controller!.value.isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
