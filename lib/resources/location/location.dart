import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/resources/pages/book_ticker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Cinema {
  final String name;
  final Position location;

  Cinema({required this.name, required this.location});
}

class Location extends StatefulWidget {
  final Map<String, dynamic> film;

  const Location({Key? key, required this.film}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  DateTime selectDate = DateTime.now();
  List<bool> expandedIndex = [];
  late Future<Position> _currentPosition;
  List<Cinema> cinemas = [
    Cinema(
        name: 'Bate Mỹ Đình',
        location: Position(
          latitude: 21.01198438587792,
          longitude: 105.77487927116421,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        )),
    Cinema(
        name: 'Beta Thanh Xuân',
        location: Position(
          latitude: 21.00286320155455,
          longitude: 105.80222395400861,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        )),
    Cinema(
        name: "Bate Văn Quán",
        location: Position(
          latitude: 20.981202313126488,
          longitude: 105.7897191074393,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        )),
    Cinema(
        name: "Bate Giải Phóng",
        location: Position(
          latitude: 20.98590082432685,
          longitude: 105.84062671167989,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        ))
  ];

  @override
  void initState() {
    super.initState();
    _currentPosition = _getCurrentLocation();
    expandedIndex = List.generate(cinemas.length, (index) => index == 0);
  }

  Future<Position> _getCurrentLocation() {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rạp phim gần bạn'),
      ),
      body: FutureBuilder<Position>(
        future: _currentPosition,
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            cinemas.sort((a, b) => Geolocator.distanceBetween(
                  snapshot.data!.latitude,
                  snapshot.data!.longitude,
                  a.location.latitude,
                  a.location.longitude,
                ).compareTo(
                  Geolocator.distanceBetween(
                    snapshot.data!.latitude,
                    snapshot.data!.longitude,
                    b.location.latitude,
                    b.location.longitude,
                  ),
                ));
            return Column(
              children: [
                Container(
                  height: height / 8,
                  child: Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final date =
                              DateTime.now().add(Duration(days: index));
                          final weekDay = DateFormat.E('vi_VN').format(date);
                          final day = DateFormat.d().format(date);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectDate =
                                    DateTime(date.year, date.month, date.day);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    index == 0 ? 'Hôm nay' : weekDay,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF595B5A),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: (selectDate.year == date.year &&
                                              selectDate.month == date.month &&
                                              selectDate.day == date.day)
                                          ? Color(0xFFAD2B33)
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: (selectDate.year ==
                                                      date.year &&
                                                  selectDate.month ==
                                                      date.month &&
                                                  selectDate.day == date.day)
                                              ? Colors.white
                                              : Color(0xFF595B5A)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cinemas.length,
                    itemBuilder: (context, index) {
                      final cinema = cinemas[index];
                      final distance = Geolocator.distanceBetween(
                            snapshot.data!.latitude,
                            snapshot.data!.longitude,
                            cinema.location.latitude,
                            cinema.location.longitude,
                          ) /
                          1000;
                      return Column(
                        children: [
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${cinema.name}'),
                                  Text('${distance.toStringAsFixed(1)} km')
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      expandedIndex[index] =
                                          !expandedIndex[index];
                                    });
                                  },
                                  icon: Icon(
                                    expandedIndex[index]
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.blue,
                                  )),
                            ),
                          ),
                          if (expandedIndex[index])
                            Container(
                                height: 50,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: <String>[
                                      '9:00',
                                      '12:00',
                                      '14:00',
                                      '16:00',
                                      '18:00',
                                      '20:00',
                                      '22:00'
                                    ].map((time) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                153, 187, 222, 251),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookTicket(
                                                          film: widget.film,
                                                          time: time,
                                                          bookingDay:
                                                              selectDate,
                                                        )),
                                              );
                                            },
                                            child: Text(
                                              time,
                                              style: TextStyle(
                                                  color: Colors.grey[900]),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList())),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
