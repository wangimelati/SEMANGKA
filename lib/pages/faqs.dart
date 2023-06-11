import 'package:flutter/material.dart';
import './accordion.dart';

class faqs extends StatefulWidget {
  @override
  _faqsState createState() => _faqsState();
}

class _faqsState extends State<faqs> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'FAQS',
          ),
        ),
        // implement several Accordion widgets in a Column
        body: Column(children: const [
          Accordion(
            title: 'Apa itu semangka to do list ?',
            content:
                'semangka to do list merupakan aplikasi yang di rancang untuk membantu mengelola tugas, dan, kehidupan sehari hari melalui fitur yang di sediakan oleh aplikasi semangka to do list. ',
          ),
          Accordion(
              title: 'Apa manfaat dari menggunakan semangka to do list ? ',
              content:
                  'dapat membantu pengguna untuk mengorganisir kegiatan pengguna sehingga pengguna dapat mencapai target kegiatan yang akan dilakukan.'),
          Accordion(
            title: 'Fitur apa saja yang ada di semangka to do list ? ',
            content: 'Fitur pomodoro\n'
                'digunakan untuk meningkatkan produktivitas dan konsentrasi pengguna dengan memecah waktu kerja menjadi periode fokus dan istirahat yang teratur.\n\n'
                'Fitur Kalender\n'
                'digunakan untuk membuat, mengedit, dan menghapus acara dengan mudah serta mengatur pengingat dan alarm untuk membantu pengguna tidak melewatkan jadwal atau acara yang penting.\n\n'
                'Fitur to do list\n'
                'digunakan untuk menyimpan daftar tugas yang harus diselesaikan, dengan menandai tugas yang sudah selesai atau yang masih harus dilakukan.\n\n',
          ),
          Accordion(
              title:
                  'Apakah aplikasi to-do list ini dapat digunakan secara bersamaan dengan teman atau rekan kerja?',
              content:
                  'tidak, saat ini aplikasi semangka to do list hanya di peruntukkan untuk penggunaan pribadi dan tidak dapat di gunakan secara bersamaan.'),
          Accordion(
              title:
                  'Apakah aplikasi to-do list ini tersedia di berbagai platform?',
              content:
                  'Ya, aplikasi semangka to do list hanya tersedia pada platform android dan IOS.'),
        ]));
  }
}
