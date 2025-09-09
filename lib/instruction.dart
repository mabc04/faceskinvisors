import 'package:faceskinvisors/Captureimage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FaceVerificationApp());
}

class FaceVerificationApp extends StatelessWidget {
  const FaceVerificationApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FaceVerificationScreen(),
    );
  }
}

class FaceVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Blue Header
            Container(
              width: double.infinity,
              color: Colors.black87,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'Reminders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Title
            Text(
              'Please follow the instructions below',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 25),

            // Face Illustration (Placeholder Circle with Icon)
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(
                Icons.person_outline,
                size: 90,
                color: Colors.blueAccent,
              ),
            ),

            SizedBox(height: 30),

            // Description Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Text(
                    'Align your face at the center of the camera.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Make sure your selfie is within the frame and you're in a well lit area.\n\nRemove anything on your face like a face mask or sunglasses.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Next Button
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CaptureImageScreen(),
                  ),
                  );
                  
                },
                child: Text
                (
                  'Next',
              
                  style: TextStyle(fontSize: 18,color: Colors.white ,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
