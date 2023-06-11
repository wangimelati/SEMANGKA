import 'package:semangka_todolist_new/Service/Auth_Service.dart';
import 'package:semangka_todolist_new/Service/Firestore_Service.dart';
import 'package:semangka_todolist_new/pages/profil.dart';
import 'package:semangka_todolist_new/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'about.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _phoneController = TextEditingController();
  String? validate(value) {
    if (value == null || value.isEmpty) {
      return 'This value cannot be empty';
    }
    return null;
  }

  @override
  void initState() {
    print('Manuk');
    initText();
    super.initState();
  }

  void initText() async {
    final data = await FireStore.getUser(Auth.getAuthUser()!.email!);
    // _textController.text = data.username;
    // _phoneController.text = data.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFACCFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF241F7B),
        title: Center(
          child: Image.asset(
            "assets/images/logo.png",
            width: 42,
            fit: BoxFit.fitWidth,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const AboutUs(),
        //         ),
        //       );
        //     },
        //     icon: const Icon(
        //       Icons.question_mark_outlined,
        //       size: 35,
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 15,
        //   )
        // ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            const SizedBox(
              height: 12,
            ),
            const Text(
              "Edit Profiles",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _textController,
                      validator: validate,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        fillColor: Color.fromARGB(35, 36, 31, 123),
                        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color.fromARGB(255, 36, 31, 123),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconColor: Color.fromARGB(255, 36, 31, 123),
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      validator: validate,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        hintText: "Phone",
                        fillColor: Color.fromARGB(35, 36, 31, 123),
                        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color.fromARGB(255, 36, 31, 123),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIconColor: Color.fromARGB(255, 36, 31, 123),
                        filled: true,
                        prefixIcon: Icon(Icons.call),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final message = await FireStore.editUser(
                                Auth.getAuthUser()!.email!,
                                [
                                  {'username': _textController.text},
                                  {'phone': _phoneController.text}
                                ],
                              );
                              if (context.mounted) {
                                if (message != 'Success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                }
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => Profil(),
                                  ),
                                );
                              }
                              // return;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 8),
                            backgroundColor: Colors.transparent,
                            foregroundColor: const Color(0xFF241F7B),
                            elevation: 0,
                            side: const BorderSide(
                                color: Color(0xFF241F7B), width: 3),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Auth.resetPassword(
                                email: Auth.getAuthUser()!.email!);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 8),
                            backgroundColor: Colors.transparent,
                            foregroundColor: const Color(0xFF241F7B),
                            elevation: 0,
                            side: const BorderSide(
                                color: Color(0xFF241F7B), width: 3),
                          ),
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}