import 'package:flutter/material.dart';

import '../constants/colors.dart';

class about extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
          title: Text('ABOUT US'),
        ),
        body: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 113, 113),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Text(
              "Selamat datang di Semangka to do list ^^ \n\n"
              "Sebuah aplikasi produktivitas yang dirancang untuk membantu mengelola waktu, tugas, dan kehidupan sehari-hari kamu melalui tiga fitur yang kami punya yaitu  to do list, kalender, dan pomodoro.\n\n"
              "Catchphrase kami adalah \"Semangat Kakak!\" karena kami percaya bahwa catchphrase tersebut terasa dekat dengan kamu dan dapat memberimu semangat seperti teman dekat.\n\n"
              "Aplikasi ini memiliki tujuan untuk membantu mengorganisir kegiatan pengguna sehingga pengguna dapat fokus pada target kegiatan yang akan dilakukan\n\n"
              "Aplikasi ini dikembangkan oleh kelompok 5:\n"
              "Aliyah Hasna		  (082111633070) \n"
              "Vika Amalia S.A	(082111633075) \n"
              "Wangi Melati A.	(082111633078) \n",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xfffffefe),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]));
  }
}
