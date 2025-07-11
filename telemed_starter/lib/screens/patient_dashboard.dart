import 'package:flutter/material.dart';
import 'appointment_screen.dart';

class PatientDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patient Dashboard")),
      body: Center(
        child: ElevatedButton(
          child: Text("Book Appointment"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AppointmentScreen()),
            );
          },
        ),
      ),
    );
  }
}
