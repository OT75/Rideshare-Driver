import 'package:cloud_firestore/cloud_firestore.dart';


Future<List<Map<String, dynamic>>> getData() async {
  List<Map<String, dynamic>> ridesData = [];

  try {
    CollectionReference rides = FirebaseFirestore.instance.collection("rides");
    QuerySnapshot querySnapshot = await rides.get();
    List<QueryDocumentSnapshot> listdocs = querySnapshot.docs;

    listdocs.forEach((element) {
      // Access the data as a Map
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;

      // Now you can print or access specific fields in the map
      print("Data Tuple:          $data");
      print("Source is:           ${data['Source']}");
      print("Destination is:      ${data['Destination']}");
      print("Time is:             ${data['Time']}");
      print("Number of seats is:  ${data['Number of Seats']}");
      print("Price is:            ${data['Price']}");
      print("Driver Email is:     ${data['Driver_Email']}");
      print("Driver ID is:        ${data['Driver_ID']}");
      // Add more fields as needed

      print("++++++++++++++++++++");

      // Add the data to the list
      ridesData.add(data);
    });
  } catch (e) {
    print("Error fetching data: $e");
  }

  return ridesData; // list of maps
}


addData(String source, String destination, String time, int numSeats, double price, String driverEmail, String driverID, String RideIDForRides, String date) async {
  try {
    CollectionReference rides = FirebaseFirestore.instance.collection("rides");

    await rides.add({
      "Source"          : source,
      "Destination"     : destination,
      "Time"            : time,
      "Number of Seats" : numSeats,
      "Price"           : price,
      "Driver_Email"    : driverEmail,
      "Driver_ID"       : driverID,
      "RideIDForRides"  : RideIDForRides,
      "Date"            : date,

    });

    print("Data added successfully!");
  } catch (e) {
    print("Error adding data: $e");
  }
}






