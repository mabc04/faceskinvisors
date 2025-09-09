import 'package:flutter/material.dart';

class TestModel extends StatelessWidget {
  const TestModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Test Model'),
      ),
      body: Center(
        child: Text('This page has a white background'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TestModel(),
  ));
}