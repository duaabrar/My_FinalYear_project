import 'package:flutter/material.dart';
import 'doctor_list_page.dart';

class FindDoctorPage extends StatelessWidget {
  const FindDoctorPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> doctorCategories = const [
    {'title': 'Family Doctor', 'icon': Icons.family_restroom},
    {'title': 'Cardiologist', 'icon': Icons.favorite},
    {'title': 'Dentist', 'icon': Icons.medical_services},
    {'title': 'Neurologist', 'icon': Icons.psychology},
    {'title': 'Orthopedic', 'icon': Icons.accessibility},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find a Doctor"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: doctorCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final category = doctorCategories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorListPage(category: category['title'])),
                );
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.teal[100], borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category['icon'], size: 40, color: Colors.teal[900]),
                    const SizedBox(height: 10),
                    Text(category['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
