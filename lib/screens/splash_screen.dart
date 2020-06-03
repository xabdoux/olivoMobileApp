import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(5, 21, 43, 1),
      body: Center(
        child: Text(
          'Loading...',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }
}
