import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorDashboard extends StatelessWidget {
  final _appointmentsRef =
      FirebaseFirestore.instance.collection('appointments');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctor Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _appointmentsRef.orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text("No appointments"));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text("Patient: ${data['patientName']}"),
                subtitle: Text("Date: ${data['date']} \nDoctor: ${data['doctor']}"),
              );
            },
          );
        },
      ),
    );
  }
}
