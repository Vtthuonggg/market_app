import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class BookTicket extends StatefulWidget {
  Map<String, dynamic> film;
  BookTicket({Key? key, required this.film}) : super(key: key);

  @override
  State<BookTicket> createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  List<bool> selectedSeats = List<bool>.generate(150, (index) => false);
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
            )
          ],
        ),
      ),
    );
  }
}
