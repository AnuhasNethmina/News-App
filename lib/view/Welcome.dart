import 'package:flutter/material.dart';
import 'package:myapp/controls/Menu.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    // Navigate to the Menu page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Menu()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/news.jpg', // Path to your image or GIF
              fit: BoxFit.cover,
            ),
          ),

          // Center the "News App" text at the center of the screen
          Center(
            child: Text(
              'News App',
              style: TextStyle(
                fontSize: 50, // Big text size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.black, // Black text color
                shadows: [
                  Shadow(
                    offset: Offset(3.0, 3.0),
                    blurRadius: 5.0,
                    color: Colors.white, // White border shadow
                  ),
                  Shadow(
                    offset: Offset(-3.0, -3.0),
                    blurRadius: 5.0,
                    color: Colors.white, // White border shadow (top-left)
                  ),
                  Shadow(
                    offset: Offset(3.0, -3.0),
                    blurRadius: 5.0,
                    color: Colors.white, // White border shadow (top-right)
                  ),
                  Shadow(
                    offset: Offset(-3.0, 3.0),
                    blurRadius: 5.0,
                    color: Colors.white, // White border shadow (bottom-left)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
