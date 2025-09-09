import 'dart:convert';
import 'dart:io';
import 'package:faceskinvisors/imagepreviewscreen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:screen_brightness/screen_brightness.dart';

import 'ResultPage.dart';

class CaptureImageScreen extends StatefulWidget {
  const CaptureImageScreen({super.key});

  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isCameraOpened = false;
  bool _isTakingPicture = false;
  bool _noCameraAvailable = false;

  // ✅ Roboflow API results
  List<String?> _processedImageUrls = [];
  List<int?> _objectCounts = [];

  // ✅ Screen brightness
  double? _previousBrightness;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _setMaxBrightness();
  }

  Future<void> _setMaxBrightness() async {
    try {
      _previousBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(1.0); // max brightness
    } catch (e) {
      debugPrint("Failed to set brightness: $e");
    }
  }

  Future<void> _restoreBrightness() async {
    if (_previousBrightness != null) {
      try {
        await ScreenBrightness().setScreenBrightness(_previousBrightness!);
      } catch (e) {
        debugPrint("Failed to restore brightness: $e");
      }
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _noCameraAvailable = true;
          _isCameraOpened = true;
        });
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      setState(() {
        _isCameraOpened = true;
        _noCameraAvailable = false;
      });
    } catch (e) {
      setState(() {
        _noCameraAvailable = true;
        _isCameraOpened = true;
      });
    }
  }

  @override
  void dispose() {
    _restoreBrightness(); // ✅ restore when leaving
    _controller?.dispose();
    super.dispose();
  }

  /// ✅ Function to call Roboflow API
  Future<void> _sendImageToRoboflow(File image) async {
    try {
      setState(() {
        _isTakingPicture = true;
        _processedImageUrls = [];
        _objectCounts = [];
      });

      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(
            'https://serverless.roboflow.com/infer/workflows/acne-chuchu/custom-workflow'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'api_key': "JoOdfUCYsESQE8HtUrxg",
          'inputs': {
            'image': {'type': 'base64', 'value': base64Image}
          }
        }),
      );

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

    setState(() {
      _isTakingPicture = false;
    });

    // ✅ Navigate to ResultPage
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

  /// ✅ Capture + crop, then send to Roboflow
  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() {
        _isTakingPicture = true;
      });

      final image = await _controller!.takePicture();
      final imageFile = File(image.path);

      final bytes = await imageFile.readAsBytes();
      final capturedImage = img.decodeImage(bytes);

      if (capturedImage != null) {
        int cropHeight = (capturedImage.height * 0.65).toInt();
        int offsetY = ((capturedImage.height - cropHeight) / 2).toInt();

        final cropped = img.copyCrop(
          capturedImage,
          x: 0,
          y: offsetY,
          width: capturedImage.width,
          height: cropHeight,
        );

        final croppedFile =
            await imageFile.writeAsBytes(img.encodeJpg(cropped));

        setState(() {
          _isTakingPicture = false;
        });

        // 👉 Navigate to Preview Page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ImagePreviewScreen(imageFile: File(croppedFile.path))),
        );
      } else {
        setState(() {
          _isTakingPicture = false;
        });
      }
    } catch (e) {
      setState(() {
        _isTakingPicture = false;
      });
      debugPrint("Error taking picture: $e");
    }
  }

  Widget _buildCameraPreview() {
    if (_noCameraAvailable) {
      return Center(
        child: ClipOval(
          child: Container(
            width: 350,
            height: 350,
            color: Colors.black,
            child: const Center(
              child: Text(
                "No Camera Available",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _controller != null) {
          return Center(
            child: ClipOval(
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.previewSize!.height,
                    height: _controller!.value.previewSize!.width,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Take a Picture",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              if (_isCameraOpened) _buildCameraPreview(),
              const SizedBox(height: 80),
              if (_isCameraOpened && !_noCameraAvailable)
                ElevatedButton(
                  onPressed: _isTakingPicture ? null : _takePicture,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: _isTakingPicture
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Take Picture"),
                ),
              const SizedBox(height: 40),
              Center(
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
      ),
    );
  }
}
