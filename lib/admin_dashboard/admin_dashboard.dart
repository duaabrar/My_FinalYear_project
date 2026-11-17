import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'doctor_management_screen.dart';
import 'lab_test_management_screen.dart';
import 'order_management_screen.dart';
import 'pharmacy_management_screen.dart';
import 'user_management_screen.dart';
import 'package:my_app/login_page.dart';

class AdminDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> dashboardItems = [
    {
      'title': 'Users',
      'icon': Icons.person,
      'collection': 'users',
      'screen': UserManagementScreen()
    },
    {
      'title': 'Lab Tests',
      'icon': Icons.biotech,
      'collection': 'lab_tests',
      'screen': LabTestManagementScreen()
    },
    {
      'title': 'Pharmacy',
      'icon': Icons.medical_services,
      'collection': 'pharmacy',
      'screen': PharmacyManagementScreen()
    },
    {
      'title': 'Doctors',
      'icon': Icons.local_hospital,
      'collection': 'doctors',
      'screen': DoctorManagementScreen()
    },
    {
      'title': 'Orders',
      'icon': Icons.list_alt,
      'collection': 'orders',
      'screen': OrderManagementScreen()
    },
  ];

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade300, Colors.blueAccent.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // App Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ADMIN DASHBOARD',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.dashboard, color: Colors.white, size: 30),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: dashboardItems.length,
                    itemBuilder: (context, index) {
                      final item = dashboardItems[index];
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(item['collection'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          // Default count from Firestore
                          int count = snapshot.hasData ? snapshot.data!.docs.length : 0;

                          // Override count for Pharmacy
                          if (item['title'] == 'Pharmacy') {
                            count = 43;
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => item['screen']),
                              );
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.95),
                                    Colors.grey.shade200
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(2, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item['icon'], size: 50, color: Colors.deepPurple),
                                  SizedBox(height: 10),
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "$count",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: () => logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
