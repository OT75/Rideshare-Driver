import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffcee3e2), // Set your preferred background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your GIF here
            Image.asset(
              'assets/loading.gif', // Replace with the correct path to your GIF
              width: screenWidth * 1, // Adjust the multiplier to control the width
              height: screenHeight * 0.8, // Adjust the multiplier to control the height
            ),

            // Example using FlareActor (replace with your GIF widget)
            // FlareActor(
            //   'assets/loading_animation.flr', // Replace with the path to your Flare animation file
            //   animation: 'loading',
            //   width: 150,
            //   height: 150,
            // ),

            SizedBox(height: 16), // Adjust the spacing between the GIF and text

            Text(
              'Welcome',
              style: TextStyle(
                color: Colors.black, // Set your preferred text color
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic
              ),
            ),
          ],
        ),
      ),
    );
  }
}
