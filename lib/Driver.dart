// Driver.dart
import 'database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart'; // for date formatting



class Driver extends StatefulWidget {
  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController seatsController = TextEditingController();
  TextEditingController dateController = TextEditingController(); // New controller

  String selectedOption = 'To Campus'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Text(
          'Add Ride',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFbbaeee),
          ),
        ),
      ),
      backgroundColor: Color(0xFFbbaeee),
      body: SingleChildScrollView(
      child : Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue!;
                    // Set default time based on the selected option
                    timeController.text = (selectedOption == 'From Campus') ? '5:30 PM' : '7:30 AM';
                  });
                },
                items: <String>['From Campus', 'To Campus']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
              SizedBox(height: 0),
              TextField(
                controller: sourceController,
                decoration: InputDecoration(
                  labelText: 'Source',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 0),
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 0),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                readOnly: true,
                onTap: () {
                  // Optionally, you can add a time picker here
                  // or let the user manually edit the time
                },
              ),
              SizedBox(height: 0),
              TextField(
                controller: seatsController,
                decoration: InputDecoration(
                  labelText: 'Number of Seats',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 0),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  // Show a date picker when the user taps the date field
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  // Update the date field if a date is selected
                  if (selectedDate != null) {
                    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Validate that none of the fields are empty
                  if (sourceController.text.isEmpty ||
                      destinationController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      timeController.text.isEmpty ||
                      seatsController.text.isEmpty ||
                      dateController.text.isEmpty) {
                    // Show an error message if any field is empty
                    _showErrorDialog(context, "All Fields must be Filled.");
                  } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(priceController.text) ||
                      !RegExp(r'^\d+$').hasMatch(seatsController.text)) {
                    _showErrorDialog(context, "Price and Number of Seats fields must be a Number!");
                  } else
                  {

                    String rideIDForRides = Uuid().v4();

                    // Check if the generated ride_id is unique in the 'ride_requests' collection
                    bool isRideIDUnique = await isUniqueID('rides', rideIDForRides);

                    if (!isRideIDUnique) {
                      // If not unique, generate a new ride_id until a unique one is found
                      while (!isRideIDUnique) {
                        rideIDForRides = Uuid().v4();
                        isRideIDUnique = await isUniqueID('rides', rideIDForRides);
                      }
                    }


                    // All fields are filled and have valid formats, proceed with handling driver information
                    String source = sourceController.text;
                    String destination = destinationController.text;
                    String time = timeController.text;
                    int numSeats = int.parse(seatsController.text);
                    double price = double.parse(priceController.text);
                    String date = dateController.text;

                    // Retrieve the driver's email
                    String? driverEmail = FirebaseAuth.instance.currentUser?.email;
                    String? driverID = FirebaseAuth.instance.currentUser?.uid;


                    // Check if driverEmail is not null (user is authenticated)
                    if (driverEmail != null) {
                      // Implement the logic for handling ride information
                      // You can use these values as needed (e.g., store in Firebase, perform validation, etc.)
                      addData(source, destination, time, numSeats, price, driverEmail, driverID!, rideIDForRides!, date);
                      _showSuccessDialog(context, 'Ride is Added successfully!');
                    } else {
                      // Show an error message if the user is not authenticated
                      _showErrorDialog(context, "Authentication error. Please log in.");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                ),
                child: Text('Submit Ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

void _showErrorDialog(BuildContext context, String message) {
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


void _showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.black, width: 3),
        ),
        backgroundColor: Color(0xF7bbaeee),
        title: Center(
          child: Text(
            '$message',
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
              // Close the dialog
              Navigator.pop(context);
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

Future<bool> isUniqueID(String collection, String id) async {
  try {
    // Query Firestore to check if the ID exists in the specified collection
    var snapshot = await FirebaseFirestore.instance.collection(collection).doc(id).get();

    // Return true if the document doesn't exist (ID is unique)
    return !snapshot.exists;
  } catch (e) {
    // Handle errors
    print('Error checking unique ID: $e');
    return false;
  }
}