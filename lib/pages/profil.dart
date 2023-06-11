
import 'package:provider/provider.dart';
import 'package:semangka_todolist_new/model/User.dart';
import 'package:semangka_todolist_new/Service/Auth_Service.dart';
import 'package:semangka_todolist_new/Service/Firestore_Service.dart';
import 'package:semangka_todolist_new/pages/edit_profile.dart';
import 'package:semangka_todolist_new/pages/auth_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:semangka_todolist_new/main.dart';
import 'package:flutter/material.dart';

import '../providers/auth2.dart';

class Profil extends StatelessWidget {
  Profil({super.key}) {
    // email = currentUser!.email!;
    // setCurrentUser();
  }

  // Future<void> setCurrentUser() async {
  //   user = await FireStore.getUser(Auth.getAuthUser()!.email!);
  // }

  User? user;

  String? email;

  String? username;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: FireStore.getUser(Auth.getAuthUser()!.email!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data as User?;
              return ProfileWidget(user: user);
            }
            return Column(
              children: const <Widget>[
                CircularProgressIndicator(
                  color: Color.fromARGB(255, 36, 31, 123),
                  semanticsLabel: 'Waiting for data',
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0XFF241F7B),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 104.7,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          user!.email,
          style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        ),
        // Text(
        //   user!.nim,
        //   style: const TextStyle(
        //       fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
        // ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          padding: const EdgeInsets.all(17),
          color: const Color(0xFF7CAEF3),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    size: 42,
                    color: Color(0xFF241F7B),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Color(0xFF241F7B),
                        ),
                      ),
                      Text(
                        user!.email,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: Color(0xFF241F7B),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.phone_android,
                    size: 42,
                    color: Color(0xFF241F7B),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Color(0xFF241F7B),
                        ),
                      ),
                      // Text(
                      //   user!.phone,
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w400,
                      //     fontFamily: 'Poppins',
                      //     color: Color(0xFF241F7B),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.people,
                    size: 42,
                    color: Color(0xFF241F7B),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Field",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Color(0xFF241F7B),
                        ),
                      ),
                      // Text(
                      //   user!.field,
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w400,
                      //     fontFamily: 'Poppins',
                      //     color: Color(0xFF241F7B),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 42,
                    color: Color(0xFF241F7B),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Grade",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Color(0xFF241F7B),
                        ),
                      ),
                      // Text(
                      //   "${user!.semester}th Semester",
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w400,
                      //     fontFamily: 'Poppins',
                      //     color: Color(0xFF241F7B),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                  backgroundColor: Colors.transparent,
                  foregroundColor: const Color(0xFF241F7B),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF241F7B), width: 3),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  onPressed: () => logoutUser(context),
                  child: const Text(
                  "LOGOUT",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                  backgroundColor: const Color(0xFFED2939),
                  foregroundColor: const Color(0xFF241F7B),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void logoutUser(BuildContext context) {
  final authProvider = Provider.of<Auth2>(context, listen: false);
  authProvider.logout();
  // Lakukan tindakan lain setelah logout
}

}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../providers/auth2.dart';
// import 'package:provider/provider.dart';


// class AccountSettingsPage extends StatefulWidget {
//   @override
//   _AccountSettingsPageState createState() => _AccountSettingsPageState();
// }

// class _AccountSettingsPageState extends State<AccountSettingsPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _auth = FirebaseAuth.instance;

//   String _errorMessage = '';

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _resetPassword() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await _auth.sendPasswordResetEmail(email: _emailController.text);
//         _showSuccessDialog('Reset password link has been sent to your email');
//       } catch (error) {
//         setState(() {
//           _errorMessage = error.toString();
//         });
//       }
//     }
//   }

//   void _showSuccessDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Success'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Account Settings'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value!.isEmpty || !value.contains('@')) {
//                     return 'Please enter a valid email address';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _resetPassword,
//                 child: Text('Reset Password'),
//               ),
//               if (_errorMessage.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: Text(
//                     _errorMessage,
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               ElevatedButton(
//   onPressed: () => logoutUser(context),
//   child: Text('Logout'),
// ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// // void logoutUser(BuildContext context) {
// //   final authProvider = Provider.of<Auth2>(context, listen: false);
// //   authProvider.logout();
// //   // Lakukan tindakan lain setelah logout
// // }


// }
