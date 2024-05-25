import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/resources/custom_toast.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/home_page_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookTicket extends StatefulWidget {
  Map<String, dynamic> film;
  String time;
  DateTime bookingDay;
  BookTicket(
      {Key? key,
      required this.film,
      required this.time,
      required this.bookingDay})
      : super(key: key);

  @override
  State<BookTicket> createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  NumberFormat vndFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  List<bool> selectedSeats = List<bool>.generate(150, (index) => false);
  getPrice() {
    num price = 0;
    DateTime now = DateTime.now();
    print('THỜI GIAN HIỆN TẠI: $now');
    String formattedDate = DateFormat("EEEE").format(now);
    print(formattedDate);
    bool isWeekend = (formattedDate == 'Friday' ||
        formattedDate == 'Satuday' ||
        formattedDate == 'Sunday');
    for (int i = 0; i < selectedSeats.length; i++) {
      if (selectedSeats[i]) {
        int row = i ~/ 11;
        price +=
            isWeekend ? (row < 4 ? 45000 : 60000) : (row < 4 ? 60000 : 75000);
      }
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt vé'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.film['title'],
                  style: GoogleFonts.oswald(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  'public/assets/images/seat.png',
                  scale: 1.5,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ": Ghế thường",
                  style: GoogleFonts.oswald(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  'public/assets/images/seat.png',
                  scale: 1.5,
                  color: Colors.blue[300],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ": Ghế VIP",
                  style: GoogleFonts.oswald(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Image.asset(
                  'public/assets/images/seat.png',
                  scale: 1.5,
                  color: Colors.red[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ": Ghế đang được chọn",
                  style: GoogleFonts.oswald(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Tổng tiền: ${vndFormat.format(getPrice())}',
                  style: GoogleFonts.oswald(fontSize: 20),
                ),
              ],
            ),
            Expanded(child: Container()),
            Divider(),
            Text(
              'MÀN HÌNH CHIẾU',
              style: GoogleFonts.oswald(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: width,
              height: height / 2.2,
              child: Expanded(
                child: GridView.builder(
                  itemCount: 121,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 11, childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    int row = index ~/ 11;
                    int seat = index % 11;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSeats[index] = !selectedSeats[index];
                        });
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Image.asset(
                            'public/assets/images/seat.png',
                            scale: 1.5,
                            color: selectedSeats[index]
                                ? Colors.red[400]
                                : row < 4
                                    ? Colors.grey[400]
                                    : Colors.blue[300],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '${String.fromCharCode(row + 65)}${seat + 1}',
                              style: GoogleFonts.oswald(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: width,
              height: height / 16,
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
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePageUser()),
                        (Route<dynamic> route) => false);
                    CustomToast.showToastSuccess(
                        description: 'Đặt vé thành công');
                  },
                  child: Text('Thanh toán',
                      style: GoogleFonts.oswald(
                          fontSize: 20, color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}
