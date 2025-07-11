import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String patientName = '';
  String selectedDoctor = '';
  String appointmentDate = '';
  bool isLoading = false;

  final doctors = ['Dr. Smith', 'Dr. Achieng', 'Dr. Patel', 'Dr. Otieno'];

  void bookAppointment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      await FirebaseFirestore.instance.collection('appointments').add({
        'patientName': patientName,
        'doctor': selectedDoctor,
        'date': appointmentDate,
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Appointment booked!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    selectedDoctor = doctors.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Your Name'),
                      onChanged: (val) => patientName = val,
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your name' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Date (e.g. 2025-07-11)'),
                      onChanged: (val) => appointmentDate = val,
                      validator: (val) =>
                          val!.isEmpty ? 'Enter a date' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedDoctor,
                      decoration: InputDecoration(labelText: 'Select Doctor'),
                      items: doctors
                          .map((doc) =>
                              DropdownMenuItem(value: doc, child: Text(doc)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedDoctor = val!),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: bookAppointment,
                      child: Text("Book Appointment"),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
