import 'package:flutter/material.dart';
import 'medicine_list_page.dart';

class BuyMedicinePage extends StatelessWidget {
  const BuyMedicinePage({Key? key}) : super(key: key);

  final List<String> categories = const ['Tablets', 'Syrups', 'Serums', 'Injections', 'Ointments'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Medicine'),
        backgroundColor: Colors.teal,
      ),
      body: Center( // ✅ Center all content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1, // ✅ Adjusted for better spacing
            ),
            itemBuilder: (context, index) {
              final type = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicineListPage(type: type),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      type,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center, // ✅ Centered text
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}