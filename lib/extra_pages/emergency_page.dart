import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  // Updated 10 official emergency numbers with description
  final List<Map<String, String>> emergencyContacts = const [
    {"name": "🚑 Ambulance", "number": "115", "desc": "Emergency medical service. Usually arrives within 10-15 mins."},
    {"name": "🏥 Nearby Hospital", "number": "1122", "desc": "Medical help & ambulance. Response time ~15-20 mins."},
    {"name": "👮 Police", "number": "15", "desc": "Report crimes or request police help. Usually arrives within 5-10 mins."},
    {"name": "🔥 Fire Brigade", "number": "16", "desc": "Fire emergencies. Response time ~10 mins depending on location."},
    {"name": "💧 Water Emergency", "number": "1234", "desc": "Water supply or leak emergencies. Usually resolves within hours."},
    {"name": "⚡ Electricity Emergency", "number": "118", "desc": "Power outage or electrical hazards. Response ~30-60 mins."},
    {"name": "🚨 Traffic Helpline", "number": "130", "desc": "Report traffic accidents. Police usually arrives in 10-15 mins."},
    {"name": "📱 Child Helpline", "number": "1098", "desc": "Child safety and protection. Response immediate."},
    {"name": "👵 Senior Citizens Helpline", "number": "1291", "desc": "Assistance for elderly citizens. Response ~10 mins."},
    {"name": "🌐 Disaster Management", "number": "0800-200-300", "desc": "Natural disaster or crisis support. Response depends on severity."},
  ];

  // Updated 10 emergency tips
  final List<Map<String, String>> emergencyTips = const [
    {
      "title": "Mental Health Crisis",
      "tip": "🧠 Talk to someone you trust. Call a helpline. Avoid being alone and seek professional help."
    },
    {
      "title": "Fire Emergency",
      "tip": "🔥 Evacuate immediately. Do not use elevators. Call the fire brigade and stay low to avoid smoke."
    },
    {
      "title": "Medical Emergency",
      "tip": "🚑 Call an ambulance. Provide first aid if trained. Keep the person calm and monitor breathing."
    },
    {
      "title": "Accident Scene",
      "tip": "🚗 Ensure safety first. Call emergency services. Do not move injured persons unless necessary."
    },
    {
      "title": "Earthquake",
      "tip": "🌍 Drop, cover, and hold on. Stay away from windows. Move to open areas after shaking stops."
    },
    {
      "title": "Flood",
      "tip": "🌊 Move to higher ground. Avoid waterlogged roads. Listen to official updates."
    },
    {
      "title": "Road Accident",
      "tip": "🚙 Ensure personal safety. Call ambulance/police. Provide first aid if possible."
    },
    {
      "title": "Heart Attack",
      "tip": "❤️ Call ambulance immediately. Keep the person calm. If trained, perform CPR."
    },
    {
      "title": "Poisoning",
      "tip": "☠️ Call emergency services or poison control. Do not induce vomiting unless instructed."
    },
    {
      "title": "Electric Shock",
      "tip": "⚡ Switch off power source. Call ambulance. Avoid touching the person directly if electricity is live."
    },
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  Future<void> _addContact() async {
    if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("emergency_contacts").add({
        "name": nameController.text.trim(),
        "number": numberController.text.trim(),
        "userId": FirebaseAuth.instance.currentUser?.uid,
        "createdAt": Timestamp.now(),
      });
      nameController.clear();
      numberController.clear();
      Navigator.pop(context);
    }
  }

  Future<void> _deleteContact(String docId) async {
    await FirebaseFirestore.instance
        .collection("emergency_contacts")
        .doc(docId)
        .delete();
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Add Emergency Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: "Name", prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                    labelText: "Phone Number", prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildTipCard(String title, String tip) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.teal[50],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 6),
            Text(tip, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🚨 Emergency Dashboard"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("📞 Official Emergency Numbers"),
          ...emergencyContacts.map((contact) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(Icons.local_phone, color: Colors.cyan),
                title: Text(contact["name"]!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact["number"]!),
                    const SizedBox(height: 4),
                    Text(contact["desc"]!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 20),
          _buildSectionTitle("👥 My Emergency Contacts"),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("emergency_contacts")
                .where("userId",
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No personal contacts added yet.");
              }
              final docs = snapshot.data!.docs;
              return Column(
                children: docs.map((doc) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.redAccent),
                      title: Text(doc["name"]),
                      subtitle: Text(doc["number"]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => _deleteContact(doc.id),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 20),
          _buildSectionTitle("🧠 Emergency Tips"),
          ...emergencyTips.map((tip) =>
              _buildTipCard(tip["title"]!, tip["tip"]!)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _showAddContactDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
