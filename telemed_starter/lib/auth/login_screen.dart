import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telemed_starter/screens/home_screen.dart';
import 'register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @overide
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState  extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Login failed: $e");
    }
  }
}