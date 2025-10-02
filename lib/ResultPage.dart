import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

    // For now, hardcoded condition (later replace with your detection logic)
    final String detectedCondition = "Blackheads".trim();

    // 🔍 Debugging
    print("DEBUG → detectedCondition = '$detectedCondition'");

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

              // 📷 Image preview
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

              // 🔥 Firestore fetch
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("Conditions")
                    .doc(detectedCondition) // ✅ trimmed
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("❌ Error: ${snapshot.error}");
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text("⚠️ No document found");
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>?;

                  if (data == null) {
                    return const Text("⚠️ Document is empty");
                  }

                  // 🔍 Debugging Firestore data
                  print("DEBUG → Firestore data: $data");

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["Name"] ?? "Unknown Condition",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data["Description"] ?? "No description available",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Recommendation:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data["Recommendation"] ??
                            "No recommendation available",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Cause:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // ✅ Cause list rendering
                      ...(data["Cause"] is List
                          ? (data["Cause"] as List<dynamic>).map((cause) {
                              return Text(
                                "- $cause",
                                style: const TextStyle(fontSize: 16),
                              );
                            }).toList()
                          : [
                              const Text(
                                "No causes available",
                                style: TextStyle(fontSize: 16),
                              )
                            ]),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // Retry button
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
