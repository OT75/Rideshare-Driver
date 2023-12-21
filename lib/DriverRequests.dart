import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverRequests extends StatefulWidget {
  const DriverRequests({Key? key}) : super(key: key);

  @override
  State<DriverRequests> createState() => _DriverRequestsState();
}

class _DriverRequestsState extends State<DriverRequests> {
  late Future<List<Map<String, dynamic>>> data;
  List<Map<String, dynamic>> driverRequests = [];

  @override
  void initState() {
    super.initState();
    data = getDriverRequests();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Driver Requests',
          style: TextStyle(
            color: Color(0xFFFFbbaeee),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF000000),
      ),
      backgroundColor: Color(0xFFbbaeee),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Build UI for displaying driver requests
            driverRequests = snapshot.data!;
            return buildDriverRequestsList(driverRequests);
          }
        },
      ),
    );
  }

  Widget buildDriverRequestsList(List<Map<String, dynamic>>? driverRequests) {
    if (driverRequests == null || driverRequests.isEmpty) {
      return Center(
        child: Text('No pending requests.'),
      );
    }

    return ListView.builder(
      itemCount: driverRequests.length,
      itemBuilder: (context, index) {
        final request = driverRequests[index];
        return buildRequestCard(request);
      },
    );
  }

  Widget buildRequestCard(Map<String, dynamic> request) {
    print(request);
    return Card(
      color: Color(0xFFbbaeee),
      elevation: 5,
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.black, width: 3),
      ),
      child: ListTile(
        onTap: () {
          // Handle tap to remove the request from the screen
          // removeRequestFromScreen(request);
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: ${request['user_id'] ?? 'N/A'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'User Email: ${request['user_email'] ?? 'N/A'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue[900],
              ),
            ),
            Text(
              'Source: ${request['Source'] ?? 'N/A'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Destination: ${request['Destination'] ?? 'N/A'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle request approval
                    handleRequestApproval(request, context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                  ),
                  child: Text(
                    'Approve',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.green,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle request cancellation
                    handleRequestCancellation(request, context);
                    // Remove the request from the screen


                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void removeRequestFromScreen(Map<String, dynamic> request) {
    setState(() {
      driverRequests.remove(request);
    });
  }

  void handleRequestApproval(Map<String,  dynamic> request, BuildContext context) async {

    bool timeConstraint = ModalRoute.of(context)!.settings.arguments as bool;

    bool isBefore11_30PM() {
      DateTime now = DateTime.now();
      DateTime elevenAndHalfPM = DateTime(now.year, now.month, now.day, 23, 30, 0); // 11:00 PM
      return now.isBefore(elevenAndHalfPM);
    }
    bool isBefore4_30PM() {
      DateTime now = DateTime.now();
      DateTime fourAndHalfPM = DateTime(now.year, now.month, now.day, 16, 30, 0); // 11:00 PM
      return now.isBefore(fourAndHalfPM);
    }


    if (timeConstraint)
    {
      if ( request['Time'] == "7:30 AM")  // To campus
        {
        if (isBefore11_30PM()) {
          try {
            String? requestID = request['document_id'];

            if (requestID != null) {
              // Update the status of the ride request to 'approved'
              await FirebaseFirestore.instance
                  .collection('ride_requests')
                  .doc(requestID)
                  .update({'status': 'Approved'});

              print("Request Approved");

              // Update the corresponding order status
              // Update the corresponding order status
              await updateOrderStatus(request, 'Approved');
              await updateRequestNumberOfSeats(request);
              await updateRideNumberofSeats(request);


              // Delete the request from ride_requests collection
              await FirebaseFirestore.instance
                  .collection('ride_requests')
                  .doc(requestID)
                  .delete();
            }
          } catch (e) {
            print('Error approving ride request: $e');
          }
          // Remove the request from the screen
          removeRequestFromScreen(request);
          _showSuccessDialog(context, "Request Approved");
          print('Before 11:30 PM');
          // You can add your logic here for the specific time, e.g., request['Time'] == "7:30 AM"
        }

        else {
          _showErrorDialog(context, "You can only deal with morning rides before 11:30 PM :(");
          // Time is after 11:00 PM
          print('After 11:30 PM');
        }
        }
      if ( request['Time'] == "5:30 PM")
        {
          if (isBefore4_30PM()) {
            try {
              String? requestID = request['document_id'];

              if (requestID != null) {
                // Update the status of the ride request to 'approved'
                await FirebaseFirestore.instance
                    .collection('ride_requests')
                    .doc(requestID)
                    .update({'status': 'Approved'});

                print("Request Approved");

                // Update the corresponding order status
                // Update the corresponding order status
                await updateOrderStatus(request, 'Approved');
                await updateRequestNumberOfSeats(request);
                await updateRideNumberofSeats(request);


                // Delete the request from ride_requests collection
                await FirebaseFirestore.instance
                    .collection('ride_requests')
                    .doc(requestID)
                    .delete();
              }
            } catch (e) {
              print('Error approving ride request: $e');
            }
            print('Before 4:30 PM');
            // You can add your logic here for the specific time, e.g., request['Time'] == "7:30 AM"
          }
          else
          {
            _showErrorDialog(context, "You can only deal with afternoon rides before 4:30 PM :(");
            // Time is after 11:00 PM
            print('After 4:30 PM');
          }
        }
    }
    if (!timeConstraint) {
      try {
        String? requestID = request['document_id'];

        if (requestID != null) {
          // Update the status of the ride request to 'approved'
          await FirebaseFirestore.instance
              .collection('ride_requests')
              .doc(requestID)
              .update({'status': 'Approved'});

          print("Request Approved");

          // Update the corresponding order status
          // Update the corresponding order status
          await updateOrderStatus(request, 'Approved');
          await updateRequestNumberOfSeats(request);
          await updateRideNumberofSeats(request);


          // Delete the request from ride_requests collection
          await FirebaseFirestore.instance
              .collection('ride_requests')
              .doc(requestID)
              .delete();
        }
      } catch (e) {
        print('Error approving ride request: $e');
      }
      // Remove the request from the screen
      removeRequestFromScreen(request);
      _showSuccessDialog(context, "Request Approved");
  }
}


  void handleRequestCancellation(Map<String, dynamic> request, BuildContext context) async {
    bool timeConstraint = ModalRoute.of(context)!.settings.arguments as bool;

    bool isBefore11_30PM() {
      DateTime now = DateTime.now();
      DateTime elevenAndHalfPM = DateTime(now.year, now.month, now.day, 23, 30, 0); // 11:00 PM
      return now.isBefore(elevenAndHalfPM);
    }
    bool isBefore4_30PM() {
      DateTime now = DateTime.now();
      DateTime elevenAndHalfPM = DateTime(now.year, now.month, now.day, 16, 30, 0); // 11:00 PM
      return now.isBefore(elevenAndHalfPM);
    }

    if(timeConstraint)
    {
      if ( request['Time'] == "7:30 AM")  // To campus
          {
        if (isBefore11_30PM()) {
          try {
            String? requestID = request['document_id'];

            if (requestID != null) {
              // Update the status of the ride request to 'cancelled'
              await FirebaseFirestore.instance
                  .collection('ride_requests')
                  .doc(requestID)
                  .update({'status': 'Cancelled'});

              print("Request Cancelled");

              // Update the corresponding order status
              await updateOrderStatus(request, 'Cancelled');

              // Delete the request from ride_requests collection
              await FirebaseFirestore.instance
                  .collection('ride_requests')
                  .doc(requestID)
                  .delete();
            }
          } catch (e) {
            print('Error cancelling ride request: $e');
          }
          print('Before 11:30 PM');
          // You can add your logic here for the specific time, e.g., request['Time'] == "7:30 AM"
        }

        else {
          _showErrorDialog(context, "You can only deal with morning rides before 11:30 PM :(");
          // Time is after 11:00 PM
          print('After 11:30 PM');
        }
      }
      if ( request['Time'] == "5:30 PM")
      {
        if (isBefore4_30PM()) {
          try {
            String? requestID = request['document_id'];

            if (requestID != null) {
              // Update the status of the ride request to 'cancelled'
              await FirebaseFirestore.instance
                  .collection('ride_requests')
                  .doc(requestID)
                  .update({'status': 'Cancelled'});

              print("Request Cancelled");

              // Update the corresponding order status
              await updateOrderStatus(request, 'Cancelled');

              // Delete the request from ride_requests collection
              await FirebaseFirestore.instance
                  .collection('ride_requests')
                  .doc(requestID)
                  .delete();
            }
          } catch (e) {
            print('Error cancelling ride request: $e');
          }
          removeRequestFromScreen(request);
          _showErrorDialog(context, "Request Cancelled");
          print('Before 4:30 PM');
          // You can add your logic here for the specific time, e.g., request['Time'] == "7:30 AM"
        }
        else
        {
          _showErrorDialog(context, "You can only deal with afternoon rides before 4:30 PM :(");
          // Time is after 11:00 PM
          print('After 4:30 PM');
        }
      }
    }


    if(!timeConstraint)
    {
    try {
      String? requestID = request['document_id'];

      if (requestID != null) {
        // Update the status of the ride request to 'cancelled'
        await FirebaseFirestore.instance
            .collection('ride_requests')
            .doc(requestID)
            .update({'status': 'Cancelled'});

        print("Request Cancelled");

        // Update the corresponding order status
        await updateOrderStatus(request, 'Cancelled');

        // Delete the request from ride_requests collection
        await FirebaseFirestore.instance
            .collection('ride_requests')
            .doc(requestID)
            .delete();
      }
    } catch (e) {
      print('Error cancelling ride request: $e');
    }
    removeRequestFromScreen(request);
    _showErrorDialog(context, "Request Cancelled");
  }
  }


  Future<void> updateOrderStatus(Map<String, dynamic> request, String status) async {
    try {
      String? rideID = request['ride_id'];

      if (rideID != null) {
        // Find and update the corresponding order in the 'orders' collection
        String? userID = request['user_id'];

        if (userID != null) {
          QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .collection('orders')
              .where('ride_id', isEqualTo: rideID)
              .get();

          if (orderSnapshot.docs.isNotEmpty) {
            // Update the status of the order
            String orderID = orderSnapshot.docs.first.id;
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .collection('orders')
                .doc(orderID)
                .update({'status': status});
          }
        }
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<void> updateRideNumberofSeats(Map<String, dynamic> request) async {
    try {
      String? rideIDForRides = request['RideIDForRides'];

      if (rideIDForRides != null) {
        String? userID = request['user_id'];

        if (userID != null) {
          CollectionReference rides = FirebaseFirestore.instance.collection('rides');

          QuerySnapshot orderSnapshot = await rides
              .where('RideIDForRides', isEqualTo: rideIDForRides)
              .get();

          print('Ride ID for Rides: $rideIDForRides');
          print('Matching documents: ${orderSnapshot.docs.length}');

          if (orderSnapshot.docs.isNotEmpty) {
            // Get the current value of 'Number of Seats'
            int currentNumberOfSeats = orderSnapshot.docs.first['Number of Seats'] ?? 0;

            // Update the status of the order
            String rideID = orderSnapshot.docs.first.id;
            int numberOfSeats = currentNumberOfSeats - 1;

            // Ensure that the value doesn't go below 0
            if (numberOfSeats >= 0) {
              await rides.doc(rideID).update({'Number of Seats': numberOfSeats});
              print('Number of Seats updated successfully.');
            } else {
              print('Number of Seats cannot be less than 0.');
            }
          } else {
            print('No order found for the provided ride ID.');
          }
        } else {
          print('User ID is null.');
        }
      } else {
        print('Ride ID for Rides is null.');
      }
    } catch (e) {
      print('Error updating number of seats: $e');
      // Handle the error appropriately (e.g., logging, error reporting, etc.)
    }
  }


  Future<void> updateRequestNumberOfSeats(Map<String, dynamic> request) async {
    try {
      String? rideID = request['ride_id'];

      if (rideID != null) {
        String? userID = request['user_id'];

        if (userID != null) {
          CollectionReference ordersCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .collection('orders');

          QuerySnapshot orderSnapshot = await ordersCollection
              .where('ride_id', isEqualTo: rideID)
              .get();

          if (orderSnapshot.docs.isNotEmpty) {
            // Get the current value of 'Number of Seats'
            int currentNumberOfSeats = orderSnapshot.docs.first['Number of Seats'] ?? 0;

            // Update the status of the order
            String orderID = orderSnapshot.docs.first.id;
            int numberOfSeats = currentNumberOfSeats - 1;

            // Ensure that the value doesn't go below 0
            if (numberOfSeats >= 0) {
              await ordersCollection.doc(orderID).update({'Number of Seats': numberOfSeats});
            } else {
              print('Number of Seats cannot be less than 0.');
            }
          } else {
            print('No order found for the provided ride ID.');
          }
        } else {
          print('User ID is null.');
        }
      } else {
        print('Ride ID is null.');
      }
    } catch (e) {
      print('Error updating number of seats: $e');
      // Handle the error appropriately (e.g., logging, error reporting, etc.)
    }
  }


  Future<List<Map<String, dynamic>>> getDriverRequests() async {
    try {
      String? driverID = FirebaseAuth.instance.currentUser?.uid;

      if (driverID != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('ride_requests')
            .where('driver_id', isEqualTo: driverID)
            .get();

        print('QuerySnapshot: $querySnapshot');

        // Get the documents with their IDs where the driver ID matches
        List<Map<String, dynamic>> requests = [];

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
          requestData['document_id'] = doc.id;
          requests.add(requestData);
        }

        return requests;
      } else {
        print('Error: Driver ID is null.');
        return [];
      }
    } catch (e, stackTrace) {
      print('Error fetching driver requests: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
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