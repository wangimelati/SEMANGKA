import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semangka_todolist_new/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final userProvider = Provider<User?>((ref) {
//   User? currentUser = FirebaseAuth.instance.currentUser;
//   return currentUser;
// });

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _email;
  late String _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', _email);
      print(_email);
        print(userCredential);
        User? user = userCredential.user;
      _formKey.currentState!.save();
      print(user);
      print(userCredential);
if (user != null) {
  print(user);
      print(userCredential);
          // Navigator.push(
          // context,
          // MaterialPageRoute(builder: (context) => Home()),
        // );
        }
      // Authenticate user with _username, _email, and _password
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email address';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Log In', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 213, 0),
                      fixedSize: Size(100, 25))),
            ],
          ),
        ),
      ),
    );
  }
}
