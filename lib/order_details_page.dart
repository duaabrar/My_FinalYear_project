import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderType;
  final String itemName;
  final String itemPrice;

  const OrderDetailsPage({
    Key? key,
    required this.orderType,
    required this.itemName,
    required this.itemPrice,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String paymentMethod = "Cash on Delivery";

  void saveOrderToFirestore() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must be logged in to place an order"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("orders").add({
      "orderType": widget.orderType,
      "itemName": widget.itemName,
      "itemPrice": widget.itemPrice,
      "customerName": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "email": user.email,
      "address": addressController.text.trim(),
      "paymentMethod": paymentMethod,
      "orderDate": DateTime.now(),
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 16),
              Text(
                "Order Placed Successfully!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context); // close alert
                  Navigator.pop(context); // go back
                },
                child: const Text("OK"),
              ),
            ),
          ],
        );
      },
    );
  }

  // ✅ Pakistan Phone Validation
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Please enter your phone";
    if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
      return "Phone must be 11 digits (Pakistan format)";
    }
    return null;
  }

  // ✅ Cancel Order Function
  void cancelOrder() {
    setState(() {
      nameController.clear();
      phoneController.clear();
      addressController.clear();
      paymentMethod = "Cash on Delivery";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Order Cancelled"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.orderType} - Order Details"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                value!.isEmpty ? "Please enter your name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: validatePhone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (value) =>
                value!.isEmpty ? "Please enter your address" : null,
              ),
              const SizedBox(height: 20),
              const Text("Payment Method",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text("Cash on Delivery"),
                leading: Radio(
                  value: "Cash on Delivery",
                  groupValue: paymentMethod,
                  onChanged: (val) {
                    setState(() {
                      paymentMethod = val!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  "Credit/Debit Card (Not available for now)",
                  style: TextStyle(color: Colors.grey),
                ),
                leading: const Icon(Icons.credit_card, color: Colors.grey),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Card payment is not available right now"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveOrderToFirestore();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text("Place Order"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: cancelOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Cancel Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
