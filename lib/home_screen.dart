import 'package:faceskinvisors/instruction.dart';
import 'package:flutter/material.dart';
import 'Captureimage.dart';
import 'Uploadimage.dart';
import 'TestModel2.dart';
import 'disclaimer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";

  Future<void> _disc() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Disclaimer()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30), // Adjusted the top margin here
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // FaceSkin Visor Text
                      Text(
                        'FaceSkin Visor',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Disclaimer Button
                      _buildDiscButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 30), // Margin between text/button and next content
                
                // Container with Box Decoration to wrap the title and buttons
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.5),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Title Text
                      const Center(
                        child: Text(
                          'A Facial Image\nDetection App\n          for\n        Acne',
                          style: TextStyle(
                            fontSize: 37,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Increase space between title and buttons
                      const SizedBox(height: 180), // Increased the gap here

                      // Upload Image and Capture Image Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(Icons.image, 'Upload Image', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestModel2()),
                            );
                          }),
                          const SizedBox(width: 5),
                          _buildActionButton(Icons.camera_alt, 'Capture Image', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FaceVerificationApp()),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Smaller border radius
        ),
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildDiscButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      onPressed: _disc,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_alert_rounded, size: 20),
          SizedBox(width: 5),
          Text('!')
        ],
      ),
    );
  }
}
