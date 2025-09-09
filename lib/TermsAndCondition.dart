import 'package:flutter/material.dart';
import 'dart:io'; 
import 'home_screen.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Disclaimer'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'For Educational Use Only.\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    TextSpan(
                      text:
                          'This app is intended for educational purposes only and should not be used as '
                          'a substitute for professional medical advice, diagnosis, or treatment. Always '
                          'seek the advice of your physician or other qualified health provider with any '
                          'questions you may have regarding a medical condition.\n\n',
                    ),
                    TextSpan(
                      text:
                          'By clicking "Agree", you have read and understood the information prescribed above.'
                          ' Otherwise, the app will close.',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: Text('Disagree'),
              ),
              ElevatedButton(
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('agreedToTerms', true);
                  // Navigate to the home screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(

                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: Text('Agree'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
