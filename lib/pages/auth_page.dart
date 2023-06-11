import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
// import 'package:flutter_login/src/models/signup_data.dart';
import 'package:provider/provider.dart';
// ini file yang pakai plugin login nya

import '../providers/auth2.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUserSignUp(SignupData data) {
    return Future.delayed(loginTime).then((_) async {
      try {
        await Provider.of<Auth2>(context, listen: false)
            .signup(data.name!, data.password!);
      } catch (err) {
        print(err);
        return err.toString();
      }
      return null;
    });
  }

  Future<String?> _authUserLogin(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      try {
        await Provider.of<Auth2>(context, listen: false)
            .login(data.name, data.password);
      } catch (err) {
        print(err);
        return err.toString();
      }
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Semangka! Planner',
      logo: 'assets/images/logo.png',
      onLogin: _authUserLogin,
      onSignup: _authUserSignUp,
      onSubmitAnimationCompleted: () {
        Provider.of<Auth2>(context, listen: false).tempData();
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
