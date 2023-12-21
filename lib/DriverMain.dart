import 'driverProfile.dart'
;import 'package:flutter/material.dart';

class DriverMain extends StatefulWidget {
  const DriverMain({Key? key});

  @override
  State<DriverMain> createState() => _DriverMainState();
}

class _DriverMainState extends State<DriverMain> {
  bool timeConstraint = true;


  @override
  Widget build(BuildContext context) {
    String? driverEmail = ModalRoute.of(context)!.settings.arguments as String?;
    print("Driver email is :" + driverEmail!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text(
                  'Driver Home',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFFFbbaeee),
                  ),
                ),
              ),
              Spacer(), // Add Spacer to push the following elements to the right
              CircleAvatar(
                backgroundColor: Colors.white, // White background
                radius: 20,
                child: IconButton(
                  icon: Icon(Icons.person, color: Colors.black), // Black icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => driverProfile(driverEmail: driverEmail),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFbbaeee),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/DriverRequests', arguments: timeConstraint);
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
                  'Requests',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Driver'); // Assuming "/rides" is the route for adding a ride
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
                  'Add Ride',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time Constraint',
                    style: TextStyle(fontSize: 30,
                        fontWeight: FontWeight.bold),

                  ),
                  Switch(
                    value: timeConstraint,
                    onChanged: (value) {
                      setState(() {
                        timeConstraint = value;
                      });
                    },
                  ),
                ],
              ),],

          ),
        ),
      ),

    );
  }
}
