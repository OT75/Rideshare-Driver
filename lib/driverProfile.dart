import 'package:flutter/material.dart';
import 'mydatabase.dart';

class driverProfile extends StatefulWidget {
  final String? driverEmail;

  const driverProfile({Key? key, this.driverEmail}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<driverProfile> {


  String username = '';
  String phoneNumber = '';
  String address = '';
  String? email;

  Future<void> fetchUserData() async {
    try {

      mydatabaseclass dbHelper = mydatabaseclass();
      email = widget.driverEmail;
      print("Fetched Driver email is " + email!);
      var userData = await dbHelper.reading(
          '''SELECT * FROM `TABLE1` WHERE `EMAIL` = '$email' '''
      );


      print('Fetched user data: $userData');

      if (userData.isNotEmpty) {
        // Assuming 'USERNAME', 'PHONE', and 'ADDRESS' are the column names in your database
        setState(() {
          username = userData[0]['USERNAME'];
          phoneNumber = userData[0]['PHONE'];
          address = userData[0]['ADDRESS'];
          print('username is : ' + username);
          print('phone is : ' + phoneNumber);
          print('address is : ' + address);
        });

        print('Updated state - username: $username, phoneNumber: $phoneNumber, address: $address');
      } else {
        print('User data is empty');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

  }

  @override
  void initState() {
    print("driver email is " + widget.driverEmail!);
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Center(
          child: Text(
            'Profile',
            style: TextStyle(
              color: Color(0xFFbbaeee),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFFbbaeee),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  username,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  email ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  address,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Dummy functionality for "Save" button
                print('username is : ' + username);
                print('phone is : ' + phoneNumber);
                print('address is : ' + address);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Print Driver Info (Terminal)",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
