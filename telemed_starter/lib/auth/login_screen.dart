import 'package:flutter/material.dart';
import '../screens/doctor_dashboard.dart';
import '../screens/patient_dashboard.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String email = '';
  String password = '';
  bool isLoading = false;

  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final result = await _authService.login(email, password);
      setState(() => isLoading = false);

      if (result == null || result['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result?['error'] ?? 'Login failed')));
        return;
      }

      if (result['role'] == 'Doctor') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => DoctorDashboard()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => PatientDashboard()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      onChanged: (val) => email = val,
                      validator: (val) =>
                          val!.isEmpty ? 'Enter email' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      validator: (val) =>
                          val!.length < 6 ? 'Password too short' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: loginUser, child: Text("Login")),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()));
                      },
                      child: Text("Don't have an account? Register"),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
