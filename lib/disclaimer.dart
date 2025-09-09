import 'home_screen.dart';
import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

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
                          'questions you may have regarding a medical condition.',
                    ),
                    TextSpan(
                      text:
                          '\n\n\n\n\n\n\n                        Version 1.0.0',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        },
              icon: Icon(Icons.arrow_back),
              label: Text('Back'),
            ),
          ),
        ],
      ),

    );
  }
}
