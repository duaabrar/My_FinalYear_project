import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyManagementScreen extends StatefulWidget {
  const PharmacyManagementScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyManagementScreen> createState() => _PharmacyManagementScreenState();
}

class _PharmacyManagementScreenState extends State<PharmacyManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedType = "Tablets";

  final CollectionReference medicines =
  FirebaseFirestore.instance.collection('medicines'); // ✅ must match FirestoreService

  Future<void> _addMedicine() async {
    if (_nameController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await medicines.add({
      'type': _selectedType, // ✅ must match BuyMedicinePage category
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': _priceController.text.trim(),
    });

    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
  }

  Future<void> _deleteMedicine(String docId) async {
    await medicines.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacy Management"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  onChanged: (value) => setState(() => _selectedType = value!),
                  items: const [
                    DropdownMenuItem(value: "Tablets", child: Text("Tablets")),
                    DropdownMenuItem(value: "Syrups", child: Text("Syrups")),
                    DropdownMenuItem(value: "Serums", child: Text("Serums")),
                    DropdownMenuItem(value: "Injections", child: Text("Injections")),
                    DropdownMenuItem(value: "Ointments", child: Text("Ointments")),
                  ],
                  decoration: const InputDecoration(labelText: "Select Type"),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Medicine Name"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addMedicine,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text("Add Medicine"),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: medicines.snapshots(), // ✅ real-time updates
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No medicines added yet"));
                }

                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name'] ?? ""),
                      subtitle: Text("${data['type']} • ${data['price']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMedicine(docs[index].id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
