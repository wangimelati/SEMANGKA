import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth2.dart';
import 'package:provider/provider.dart';


class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? id;
  // String? email;

  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // @override
  // void initState() async{
  //   print("halo");
  //   // getData();
  // }

//   void getData()async{
// final prefs = await SharedPreferences.getInstance();
//     // final _uid = prefs.getString('id');
//     // final authData = prefs.get('authData');
//     // print(prefs.get('authData'));
//     Map<String, dynamic> data = jsonDecode(prefs.get("authData") as String) as Map<String, dynamic>;
//   String iniId = data['uid'];
//   setState(() {
//     id = iniId;
//   });
//   }

  Future<void> _resetPassword() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("email");
      print(email);
      // ;
      // setState(() {
      //   email = prefs.getString("email")!;
      // });
      // String? email = prefs.getString('email');
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
    print('Email reset password berhasil dikirim');
  } catch (error) {
    print('Terjadi kesalahan saat mengirim email reset password: $error');
  }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('Reset Password'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
  onPressed: () => logoutUser(context),
  child: Text('Logout'),
),
            ],
          ),
        ),
      ),
    );
  }

void logoutUser(BuildContext context) {
  final authProvider = Provider.of<Auth2>(context, listen: false);
  authProvider.logout();
  // Lakukan tindakan lain setelah logout
}


}