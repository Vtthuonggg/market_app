import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/login_api.dart';
import 'package:flutter_app/resources/pages/home_page_user.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 90, 164),
                  Color.fromARGB(255, 139, 203, 255)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Đăng nhập',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 150,
                      height: 150,
                      child: Image.asset('public/assets/images/logo_bate.png')),
                  TextFormField(
                    controller: _username,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    cursorColor: Colors.blue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey[400]!)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: 'Email hoặc tên đăng nhập',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.grey[400]!),
                      prefix: VerticalDivider(color: Colors.green),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _password,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    cursorColor: Colors.blue,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không được để trống';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey[400]!)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: 'Mật khẩu',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.lock_open_outlined,
                          color: Colors.grey[400]!),
                      prefix: VerticalDivider(color: Colors.green),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Quên mật khẩu?',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.blue[900],
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                      width: width,
                      height: height / 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 229, 88, 0),
                            Color.fromARGB(255, 242, 198, 76)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final apiService = ApiService();
                          final loginApi = TMDBLoginApi(apiService);
                          final username = _username.text;
                          final password = _password.text;
                          final success =
                              await loginApi.login(username, password);
                          if (success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePageUser(username: username)),
                            );
                          } else {}
                        },
                        child: Text('ĐĂNG NHẬP',
                            style: GoogleFonts.oswald(
                                fontSize: 20, color: Colors.white)),
                      )),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Divider(
                            color: Colors.grey,
                            height: 50,
                          ),
                        ),
                      ),
                      Text(
                        "Hoặc",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(
                            color: Colors.grey,
                            height: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      const url = 'https://www.themoviedb.org/account/signup';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text('Đăng ký tài khoản',
                        style: GoogleFonts.oswald(
                            fontSize: 20, color: Colors.grey[700])),
                  ),
                ],
              ),
            ),
          )),
        ));
  }
}
