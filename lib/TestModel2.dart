import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';
import 'ResultPage.dart';

class TestModel2 extends StatefulWidget {
  const TestModel2({super.key});

  @override
  _TestModel2State createState() => _TestModel2State();
}

class _TestModel2State extends State<TestModel2> {
        Widget _buildLegendBox(Color color, String label) {
        return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black26),
                ),
            ),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 14)),
            ],
        );
        }


  final picker = ImagePicker();
  List<File> _images = [];
  List<String?> _processedImageUrls = [];
  List<int?> _objectCounts = [];
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.take(3).map((file) => File(file.path)).toList();
        _processedImageUrls = [];
        _objectCounts = [];
      });
    }
  }

  Future<void> _sendImageToRoboflow() async {
    if (_images.isEmpty) return;

    setState(() {
      _isLoading = true;
      _processedImageUrls = [];
      _objectCounts = [];
    });

    for (var image in _images) {
      try {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);

        final response = await http.post(
          Uri.parse('https://serverless.roboflow.com/infer/workflows/acne-chuchu/custom-workflow'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'api_key': "JoOdfUCYsESQE8HtUrxg",
            'inputs': {
              'image': {'type': 'base64', 'value': base64Image}
            }
          }),
        );
        // https://serverless.roboflow.com/infer/workflows/acne-chuchu/custom-workflow demo1 JoOdfUCYsESQE8HtUrxg
        // https://serverless.roboflow.com/infer/workflows/code-qjcxw/custom-workflow' demo2 LGJpUgdRWaxjZJILrf7F
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final outputs = data['outputs'];

          if (outputs != null && outputs is List && outputs.isNotEmpty) {
            final firstOutput = outputs[0];
            final detectionVis = firstOutput['label_visualization'];
            final countObjects = firstOutput['count_objects_block1'];

            _processedImageUrls.add(
              detectionVis != null && detectionVis['value'] != null
                  ? detectionVis['value'] as String
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
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ResultPage(
      processedImageUrls: _processedImageUrls,
      objectCounts: _objectCounts,
    ),
  ),
);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Upload Images',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Insert from Gallery',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please make sure the images are clear before proceeding',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    _images.isNotEmpty
                        ? Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _images.map((img) {
                              return Image.file(img,
                                  height: 100, width: 100, fit: BoxFit.cover);
                            }).toList(),
                          )
                        : const Text('(No image files selected)',
                            style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _sendImageToRoboflow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator(),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 5),
                    Text("Back"),
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
