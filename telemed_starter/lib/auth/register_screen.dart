import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String name = '';
  String email = '';
  String password = '';
  String role = 'Patient'; // default

  bool isLoading = false;

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      String? error = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      setState(() => isLoading = false);

      if (error != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      onChanged: (val) => name = val,
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your name' : null,
                    ),
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
                    DropdownButtonFormField<String>(
                      value: role,
                      items: ['Doctor', 'Patient']
                          .map((role) =>
                              DropdownMenuItem(value: role, child: Text(role)))
                          .toList(),
                      onChanged: (val) => role = val!,
                      decoration: InputDecoration(labelText: 'Role'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: registerUser, child: Text("Register")),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: Text("Already have an account? Login"),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
