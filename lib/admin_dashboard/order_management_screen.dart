import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  Future<void> deleteOrder(String orderId) async {
    await FirebaseFirestore.instance.collection("orders").doc(orderId).delete();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .update({"status": newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Orders"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .orderBy("orderDate", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              final orderData = order.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(orderData['itemName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Type: ${orderData['orderType']}"),
                      Text("Price: ${orderData['itemPrice']}"),
                      Text("Customer: ${orderData['customerName']}"),
                      Text("Phone: ${orderData['phone']}"),
                      Text("Payment: ${orderData['paymentMethod']}"),
                      Text("Status: ${orderData.containsKey('status') ? orderData['status'] : 'Pending'}"),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "delete") {
                        deleteOrder(order.id);
                      } else {
                        updateOrderStatus(order.id, value);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "Completed",
                        child: Text("Mark as Completed"),
                      ),
                      const PopupMenuItem(
                        value: "Pending",
                        child: Text("Mark as Pending"),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text(
                          "Delete Order",
                          style: TextStyle(color: Colors.red),
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
    );
  }
}
