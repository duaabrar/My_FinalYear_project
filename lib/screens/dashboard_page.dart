import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Old Pages
import 'package:my_app/lab_test_folder/lab_test_page.dart';
import 'package:my_app/buy_medicine/buy_medicine_page.dart';
import 'package:my_app/find_doctor/find_doctor_page.dart';
import 'package:my_app/chatbot/chatbot_page.dart';
import 'package:my_app/login_page.dart';
import 'package:my_app/order_info/info.dart';

// New Pages
import 'package:my_app/extra_pages/bmi_calculator_page.dart';
import 'package:my_app/extra_pages/daily_tips_page.dart';
import 'package:my_app/extra_pages/health_news_page.dart';
import 'package:my_app/extra_pages/reminders_page.dart';
import 'package:my_app/extra_pages/emergency_page.dart';
import 'package:my_app/find_doctor/AppointmentsHistoryPage.dart';
import 'package:my_app/extra_pages/reminders_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  final List<Map<String, dynamic>> dashboardItems = [
    {
      'title': 'Lab Test',
      'icon': Icons.bloodtype,
      'color': Colors.blueAccent,
      'page': const LabTestListPage(),
    },
    {
      'title': 'Buy Medicine',
      'icon': Icons.medical_services,
      'color': Colors.deepOrange,
      'page': const BuyMedicinePage(),
    },
    {
      'title': 'Find Doctor',
      'icon': Icons.person_search,
      'color': Colors.lightGreen,
      'page': const FindDoctorPage(),
    },
    {
      'title': 'Healbot',
      'icon': Icons.smart_toy,
      'color': Colors.purpleAccent,
      'page': ChatPage(),
    },
    {
      'title': 'Order History',
      'icon': Icons.receipt_long,
      'color': Colors.orange,
      'page': const InfoPage(),
    },
    {
      'title': 'BMI Calculator',
      'icon': Icons.monitor_weight,
      'color': Colors.pink,
      'page': const BMICalculatorPage(),
    },
    {
      'title': 'My Appointments',
      'icon': Icons.calendar_today,
      'color': Colors.teal,
      'page': const AppointmentHistoryPage(),
    },
  ];

  final List<Map<String, dynamic>> navItems = [
    {
      'title': "Home",
      'icon': Icons.home,
      'page': const BMICalculatorPage(),
    },
    {
      'title': "Daily Tips",
      'icon': Icons.lightbulb,
      'page': const DailyTipsPage(),
    },
    {
      'title': "News",
      'icon': Icons.newspaper,
      'page': const NewsPage(),
    },
    {
      'title': "Symptoms",
      'icon': Icons.add_circle,
      'page':  SymptomGuideScreen(),
    },
    {
      'title': "Emergency",
      'icon': Icons.call,
      'page': const EmergencyPage(),
    },
  ];

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal,
                child: Text(
                  user?.email != null ? user!.email![0].toUpperCase() : "U",
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user?.email ?? "Guest User",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Widget> bottomPages = navItems.map((item) => item['page'] as Widget).toList();

    return Scaffold(
      body: SafeArea(
        child: _selectedIndex == 0
            ? Column(
          children: [
            // Top Header
            Container(
              height: screenHeight * 0.3,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(24)),
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.greenAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "HealSphere",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 41,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Where Wellness Begins",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'cursive',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Profile Button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      onPressed: _showProfileMenu,
                      icon: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.tealAccent.shade700,
                        child: Text(
                          user?.email != null
                              ? user!.email![0].toUpperCase()
                              : "U",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Quick Access Buttons
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                  const BuyMedicinePage()),
                            );
                          },
                          icon: const Icon(Icons.medical_services,
                              color: Colors.white),
                          tooltip: "Medicines",
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                  const FindDoctorPage()),
                            );
                          },
                          icon: const Icon(Icons.person_search,
                              color: Colors.white),
                          tooltip: "Doctors",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Dashboard Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 20),
                child: GridView.builder(
                  itemCount: dashboardItems.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final item = dashboardItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => item['page']));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'],
                                color: item['color'], size: 40),
                            const SizedBox(height: 10),
                            Text(item['title'],
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        )
            : bottomPages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: navItems
            .map((item) => BottomNavigationBarItem(
            icon: Icon(item['icon']), label: item['title']))
            .toList(),
      ),
    );
  }
}
