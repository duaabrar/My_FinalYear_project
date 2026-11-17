import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("You must be logged in to view orders"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("email", isEqualTo: user.email)
            .snapshots(), // ✅ removed orderBy to avoid missing field issues
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var orders = snapshot.data!.docs.reversed.toList(); // show latest first

          if (orders.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(order["itemName"] ?? "Unknown Item"),
                  subtitle: Text(
                      "${order["orderType"] ?? "-"} • ${order["itemPrice"] ?? "-"} • ${order["paymentMethod"] ?? "-"}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailView(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailView extends StatelessWidget {
  final QueryDocumentSnapshot order;

  const OrderDetailView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timestamp? orderTimestamp = order["orderDate"] as Timestamp?;
    String orderDateStr = orderTimestamp != null
        ? orderTimestamp.toDate().toString()
        : "Unknown";

    return Scaffold(
      appBar: AppBar(
        title: Text(order["itemName"] ?? "Order Detail"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Type: ${order["orderType"] ?? "-"}"),
            Text("Price: ${order["itemPrice"] ?? "-"}"),
            Text("Customer Name: ${order["customerName"] ?? "-"}"),
            Text("Phone: ${order["phone"] ?? "-"}"),
            Text("Email: ${order["email"] ?? "-"}"),
            Text("Address: ${order["address"] ?? "-"}"),
            Text("Payment Method: ${order["paymentMethod"] ?? "-"}"),
            Text("Order Date: $orderDateStr"),
          ],
        ),
      ),
    );
  }
}
