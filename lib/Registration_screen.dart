import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String gender = "Male"; // Default gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Face\nSkinVisor",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Registration",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Full name",
                            hintText: "Juan Dela Cruz",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Password
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Enter password",
                            hintText: "At least 12 characters",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Confirm Password
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Enter confirm password",
                            hintText: "At least 12 characters",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Age
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter age",
                            hintText: "In years",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Gender Selection
                        Row(
                          children: [
                            Text("Gender"),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Radio(
                                  value: "Male",
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value.toString();
                                    });
                                  },
                                ),
                                Text("Male"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: "Female",
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value.toString();
                                    });
                                  },
                                ),
                                Text("Female"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Register Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (Context) => HomeScreen()),
                  );
                  if (_formKey.currentState!.validate()) {
                    // Handle registration logic here
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text("Register", style: TextStyle(color: Colors.white)),
              ),

              SizedBox(height: 10),

              // Go Back Link
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Have an account? Go back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
