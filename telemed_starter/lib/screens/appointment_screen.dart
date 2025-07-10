import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String? selectedDoctor;
  DateTime selectedDate = DateTime.now();

  void bookAppointment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (selectedDoctor == null) return;

    await FirebaseFirestore.instance.collection('appointments').add({
      'patient': user!.email,
      'doctor': selectedDoctor,
      'date': selectedDate.toIso8601String()
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully')));
  }

  @override
  Widget build(BuildContext context) {
    final doctors = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Doctor')
        .snapshots();

    return Scaffold(
        appBar: AppBar(title: Text("Book Appointment")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            StreamBuilder<QuerySnapshot>(
              stream: doctors,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return DropdownButton<String>(
                  hint: Text("Select Doctor"),
                  value: selectedDoctor,
                  items: docs
                      .map((doc) => DropdownMenuItem<String>(
                        value: doc['email'] as String,
                        child: Text(doc['name'] as String),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedDoctor = val;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: bookAppointment, child: Text("Book Appointment"))
          ]),
        ));
  }
}
