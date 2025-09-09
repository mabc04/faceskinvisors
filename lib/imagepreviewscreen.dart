import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ResultPage.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File imageFile;

  const ImagePreviewScreen({super.key, required this.imageFile});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _isLoading = false;
  List<String?> _processedImageUrls = [];
  List<int?> _objectCounts = [];

  Future<void> _sendImageToRoboflow(File image) async {
    setState(() {
      _isLoading = true;
      _processedImageUrls = [];
      _objectCounts = [];
    });

    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("https://serverless.roboflow.com/infer/workflows/acne-chuchu/custom-workflow"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "api_key": "JoOdfUCYsESQE8HtUrxg",
          "inputs": {
            "image": {"type": "base64", "value": base64Image}
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final outputs = data["outputs"];

        if (outputs != null && outputs is List && outputs.isNotEmpty) {
          final firstOutput = outputs[0];
          final detectionVis = firstOutput["label_visualization"];
          final countObjects = firstOutput["count_objects_block1"];

          _processedImageUrls.add(
            detectionVis != null && detectionVis["value"] != null
                ? detectionVis["value"] as String
                : null,
          );
          _objectCounts.add(countObjects);
        } else {
          _processedImageUrls.add(null);
          _objectCounts.add(null);
        }
      } else {
        _processedImageUrls.add(null);
        _objectCounts.add(null);
      }
    } catch (e) {
      _processedImageUrls.add(null);
      _objectCounts.add(null);
    }

    setState(() {
      _isLoading = false;
    });

    // 👉 Navigate to results page
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            processedImageUrls: _processedImageUrls,
            objectCounts: _objectCounts,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Confirmation",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.contain,
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Retry → back to camera
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () => _sendImageToRoboflow(widget.imageFile),
              icon: const Icon(Icons.check),
              label: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
