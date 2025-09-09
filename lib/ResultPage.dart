import 'dart:convert';
import 'dart:typed_data';
import 'package:faceskinvisors/TestModel.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'TestModel2.dart';

class ResultPage extends StatelessWidget {
  final List<String?>? processedImageUrls;
  final List<int?>? objectCounts;
  final Uint8List? imageBytes;

  const ResultPage({
    super.key,
    this.processedImageUrls,
    this.objectCounts,
    this.imageBytes,
  });

  factory ResultPage.fromBytes(Uint8List imageBytes) {
    return ResultPage(imageBytes: imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? displayImage = imageBytes ??
        (processedImageUrls != null &&
                processedImageUrls!.isNotEmpty &&
                processedImageUrls!.first != null
            ? base64Decode(processedImageUrls!.first!)
            : null);

    final int objectCount = objectCounts != null &&
            objectCounts!.isNotEmpty &&
            objectCounts!.first != null
        ? objectCounts!.first!
        : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Analysis Result',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: displayImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(displayImage, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Text(
                            '📷 Captured Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TestModel2()),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.autorenew, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Retry', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
