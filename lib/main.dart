import 'DriverLoginAndSignup.dart';
import 'DriverMain.dart';
import 'DriverRequests.dart';
import 'DriverSignup.dart';
import 'driverProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Driver.dart';
import 'firebase_options.dart';
import 'mydatabase.dart';
import 'loadingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Simulate some initialization tasks
  Future<void> _initialize() async {
    // Add your initialization tasks here
    await Future.delayed(Duration(seconds: 5)); // Simulating a delay of 2 seconds
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF2B2B2C),
        hintColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      home: FutureBuilder(
        future: _initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Initialization is complete, navigate to LoginPage
            return DriverLoginAndSignup();
          } else {
            // Initialization is in progress, show a splash screen
            return SplashScreen(); // You need to create a SplashScreen widget
          }
        },
      ),
      routes: {
        '/DriverSignup': (context) => DriverSignup(),
        '/DriverMain': (context) => DriverMain(),
        '/Driver': (context) => Driver(),
        '/DriverRequests': (context) => DriverRequests(),
        '/driverProfile': (context) => driverProfile(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingScreen(); // Use your loading screen widget
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
