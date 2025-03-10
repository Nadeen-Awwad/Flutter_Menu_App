import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dashboard/screens/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال بعد 3 ثواني للـ Dashboard
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // تأكد إن الصورة موجودة في pubspec.yaml
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
