import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'AnalysisResult.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Upload Image',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
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
                      padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Insert Image from Gallery',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please make sure the image is clear before proceeding',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  _image != null
                      ? Image.file(
                          _image!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        )
                      : Text(
                          '(No image file selected)',
                          style: TextStyle(color: Colors.black54),
                        ),
                        
                ],
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () { //DITO YUNG API CALL FOR UPLOAD
                if (_image != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnalysisResultScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select an image first'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: Text('Submit'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
            ),
          ], 
        ),
      ),
    );
  }
}