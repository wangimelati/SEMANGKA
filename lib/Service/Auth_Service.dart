import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Auth {
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    User? user;
    String? message;
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user;
      // message = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else {
        message = 'Unknown Failed';
      }
    }
    return message;
  }

  static Future<String> logOut() async {
    String message;
    try {
      await FirebaseAuth.instance.signOut();
      message = 'Success';
    } on FirebaseAuthException catch (e) {
      message = e.message!;
    }
    return message;
  }

  static User? getAuthUser() {
    User? user;
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        user = FirebaseAuth.instance.currentUser;
        print(user!.email);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
    return user;
  }

  static Future<String?> resetPassword({required String email}) async {
    User? user;
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        user = FirebaseAuth.instance.currentUser;
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        return 'Success';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}