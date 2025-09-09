import 'package:faceskinvisors/TestModel.dart';
import 'package:faceskinvisors/TestModel2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TermsAndCondition.dart';
import 'home_screen.dart'; // Import HomeScreen if necessary

class SkinFaceVisorScreen extends StatefulWidget {
  @override
  _SkinFaceVisorScreenState createState() => _SkinFaceVisorScreenState();
}

class _SkinFaceVisorScreenState extends State<SkinFaceVisorScreen> {
  @override
  void initState() {
    super.initState();
    _checkAgreementStatus();
  }

  Future<void> _checkAgreementStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasAgreed = prefs.getBool('agreedToTerms') ?? false;

    // Wait for 2 seconds (loading screen duration)
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to the appropriate screen based on whether the user has agreed to the terms
      if (hasAgreed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TermsAndCondition()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "loading, please wait...",
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.0,
                color: Colors.black,
                fontFamily: 'Arial',
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}
