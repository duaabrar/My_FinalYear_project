import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorManagementScreen extends StatefulWidget {
  const DoctorManagementScreen({Key? key}) : super(key: key);

  @override
  _DoctorManagementScreenState createState() => _DoctorManagementScreenState();
}

class _DoctorManagementScreenState extends State<DoctorManagementScreen> {
  final List<String> categories = [
    'Family Doctor',
    'Cardiologist',
    'Dentist',
    'Neurologist',
    'Orthopedic',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Management"), backgroundColor: Colors.teal),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorListAdminPage(category: categories[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DoctorListAdminPage extends StatelessWidget {
  final String category;
  DoctorListAdminPage({Key? key, required this.category}) : super(key: key);

  final CollectionReference doctorsRef = FirebaseFirestore.instance.collection('doctors');

  void _showDoctorDialog(BuildContext context, {DocumentSnapshot? doc}) {
    final nameController = TextEditingController(text: doc != null ? doc['name'] : '');
    final specialityController = TextEditingController(text: doc != null ? doc['speciality'] : '');
    final feeController = TextEditingController(text: doc != null ? doc['fee'] : '');
    final hospitalController = TextEditingController(text: doc != null ? doc['hospital'] : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(doc != null ? "Edit Doctor" : "Add Doctor"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Doctor Name")),
              TextField(controller: specialityController, decoration: const InputDecoration(labelText: "Speciality")),
              TextField(controller: feeController, decoration: const InputDecoration(labelText: "Fee")),
              TextField(controller: hospitalController, decoration: const InputDecoration(labelText: "Hospital")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (doc == null) {
                await doctorsRef.add({
                  'category': category,
                  'name': nameController.text,
                  'speciality': specialityController.text,
                  'fee': feeController.text,
                  'hospital': hospitalController.text,
                });
              } else {
                await doctorsRef.doc(doc.id).update({
                  'name': nameController.text,
                  'speciality': specialityController.text,
                  'fee': feeController.text,
                  'hospital': hospitalController.text,
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDoctor(String id) async {
    await doctorsRef.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$category Doctors"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: doctorsRef.where('category', isEqualTo: category).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading doctors"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final doctors = snapshot.data!.docs;
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doc = doctors[index];
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text("${doc['speciality']} - ${doc['hospital']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showDoctorDialog(context, doc: doc),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDoctor(doc.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () => _showDoctorDialog(context),
      ),
    );
  }
}
