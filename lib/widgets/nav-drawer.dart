import 'package:flutter/material.dart';
import '../pages/auth_page.dart';

import '../pages/profil.dart';
import '../pages/set_akun.dart';
import '../pages/about.dart';
import '../pages/faqs.dart';
import '../providers/auth2.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _drawerItem(
              icon: Icons.person,
              text: 'Setting Akun',
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                      // ini return nya masih salah page.
                  return AccountSettingsPage(); 
                }));
              }),
          _drawerItem(
              icon: Icons.support_agent,
              text: 'About Us',
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return about();
                }));
              }),
          _drawerItem(
              icon: Icons.quiz_rounded,
              text: 'FAQS',
              onTap: () {Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return faqs();
                }));}),
          // _drawerItem(
          //     icon: Icons.logout_outlined,
          //     text: 'Log Out',
          //     onTap: () {
          //       Navigator.of(context)
          //           .push(MaterialPageRoute(builder: (context) {
          //         return logoutUser();
          //       }));
          //     }),
        ],
      ),
    );
  }
}

// void logoutUser(BuildContext context) {
//   final authProvider = Provider.of<Auth2>(context, listen: false);
//   authProvider.logout();
//   // Lakukan tindakan lain setelah logout
// }


Widget _drawerHeader() {
  return UserAccountsDrawerHeader(
    currentAccountPicture: ClipOval(
      child: Image(
          image: AssetImage('assets/images/avatar.jpg'), fit: BoxFit.cover),
    ),
    accountName: Text('Siapa Yhhhh'),
    accountEmail: Text('iniemailnya@gmail.com'),
  );
}

Widget _drawerItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}
