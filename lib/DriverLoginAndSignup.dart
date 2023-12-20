import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverLoginAndSignup extends StatefulWidget {
  @override
  _DriverLoginAndSignupState createState() => _DriverLoginAndSignupState();
}

class _DriverLoginAndSignupState extends State<DriverLoginAndSignup> {
  String email = '';
  String password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      if (!email.endsWith('@driver.com')) {
        _showErrorDialog(context, 'Error: Email must have the domain (@driver.com)');
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the home page or perform any other actions after successful login
      Navigator.pushReplacementNamed(context, "/DriverMain", arguments: email);
      print('User logged in: ${userCredential.user!.uid}');
    } catch (e) {
      // Handle sign-in errors
      _showErrorDialog(context, e.toString());
    }
  }


  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.black, width: 3),
          ),
          backgroundColor: Color(0xF7bbaeee),
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFFFF0000),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFFF0000),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Center(
          child: Text(
            'Welcome to Rideshare (Driver)',
            style: TextStyle(
              color: Color(0xFFFFbbaeee),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFbbaeee),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black,
                    fontSize: 20,
                  ),
                  prefixIcon: Icon(Icons.email_rounded, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black,
                      fontSize: 20),
                  prefixIcon: Icon(Icons.lock_rounded, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  loginUser(context, email, password);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16),
                ),
              ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/DriverSignup');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            'Don\'t have an account? Sign up here',
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 17,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

            ],
          ),
        ),
      ),
    );
  }
}
