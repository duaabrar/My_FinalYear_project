import 'package:flutter/material.dart';
import 'package:my_app/find_doctor/DoctorAppointmentPage.dart';

class DoctorDetailPage extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  const DoctorDetailPage({Key? key, required this.doctorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = doctorData['name'] ?? 'Unknown Doctor';
    String speciality = doctorData['speciality'] ?? 'Speciality not available';
    String hospital = doctorData['hospital'] ?? 'Hospital not available';
    String fee = doctorData['fee'] ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Doctor Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.medical_services, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(speciality,
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.local_hospital, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(hospital,
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.teal),
                      const SizedBox(width: 8),
                      Text("Fee: $fee",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoctorAppointmentPage(
                        orderType: "Doctor Appointment",
                        itemName: name,
                        itemPrice: fee.toString(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                label: const Text(
                  "Book Appointment",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
