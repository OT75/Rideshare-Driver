import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'mydatabase.dart';
import 'package:sqflite/sqflite.dart';


class DriverSignup extends StatefulWidget {
  const DriverSignup({super.key});

  @override
  State<DriverSignup> createState() => _DriverSignupState();
}

class _DriverSignupState extends State<DriverSignup> {

  mydatabaseclass mydb = mydatabaseclass();
  List<Map> mylist = [];

  Future Reading_Database() async {
    List<Map> response = await mydb.reading('''SELECT * FROM 'TABLE1' ''');
    mylist = [];
    mylist.addAll(response);
    setState(() {});
  }

  @override
  void initState() {
    Reading_Database();
    super.initState();
    mydb.checking();
  }
  String username = '';
  String email = '';
  String password = '';
  String phone = '';
  String address = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Center(
          child: Text(
            'Sign-Up',
            style: TextStyle(
              color: Color(0xFFbbaeee),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFFbbaeee),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Create an Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.person_rounded, color: Colors.black,size: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
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
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.email_rounded, color: Colors.black,size: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
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
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.lock_rounded, color: Colors.black,size: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
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
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),


              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: TextStyle(color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.phone_rounded, color: Colors.black,size: 30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
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
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {
                      phone = value;
                    });
                  },
                ),
              ),

              // New address field
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.location_on_rounded, color: Colors.black,size: 30),
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
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Perform signup logic (dummy in this case)
                  signUp(context, username, email, password, phone, address);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Border radius
                  ),
                ),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void signUp(BuildContext context, String username, String email, String password, String phone, String address) async {
  try {
    // Check if any of the fields is empty
    if (username.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty || address.isEmpty) {
      return _showErrorDialog(context, 'Error: All fields must be filled.');
    }

    // Check if the email has the desired domain
    if (!email.endsWith('@driver.com')) {
      return _showErrorDialog(context, 'Error: Email must have the domain (@driver.com)');
    }

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _performSignUp(context, email);
    _sqfliteStore(username, email, phone, address);


    // Handle additional actions after successful sign-up
    print('User signed up: ${userCredential.user!.uid}');
  } catch (e) {
    String removeStringInsideBrackets(String input) {
      RegExp regex = RegExp(r'\[.*?\]');
      return input.replaceAll(regex, '');
    }

    // Handle sign-up errors
    String errorMessage = e.toString();
    String filteredMessage = removeStringInsideBrackets(errorMessage);
    _showErrorDialog(context, filteredMessage);
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
void _performSignUp(BuildContext context, String driverEmail) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Set the border radius
          side: BorderSide(color: Colors.black, width: 3),
          // Set the border color
        ),
        backgroundColor: Color(0xF7bbaeee),
        title: Center(
          child: Text(
            'You Signed Up Successfully!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF0FFF50),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/DriverMain",arguments: driverEmail);
            },
            child: Center(
              child: Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF0FFF50),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _sqfliteStore(String username, String email, String phone, String address) async {
  try {
    mydatabaseclass dbHelper = mydatabaseclass(); // Create an instance of the SQLite helper class
    Database? mydb = await dbHelper.mydbcheck(); // Check if the database is open

    if (mydb != null) {
      // Insert user information into the SQLite database
      String sql = '''
        INSERT INTO TABLE1 ('USERNAME', 'EMAIL', 'PHONE', 'ADDRESS')
        VALUES ('$username', '$email', '$phone', '$address')
      ''';

      int result = await mydb.rawInsert(sql);

      if (result != -1) {
        print('User information stored in SQLite database');
      } else {
        print('Failed to store user information in SQLite database');
      }
    } else {
      print('SQLite database is not open');
    }
  } catch (e) {
    print('Error in _sqfliteStore: $e');
  }
}
}


