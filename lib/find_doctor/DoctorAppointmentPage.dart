import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentPage extends StatefulWidget {
  final String orderType;
  final String itemName;
  final String itemPrice;

  const DoctorAppointmentPage({
    Key? key,
    required this.orderType,
    required this.itemName,
    required this.itemPrice,
  }) : super(key: key);

  @override
  State<DoctorAppointmentPage> createState() => _DoctorAppointmentPageState();
}

class _DoctorAppointmentPageState extends State<DoctorAppointmentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void _confirmAppointment() async {
    if (_formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null) {
      // Save to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'doctorName': widget.itemName,
        'fee': widget.itemPrice,
        'date': selectedDate!.toIso8601String(),
        'time': selectedTime!.format(context),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: const Text(
            "Appointment booked successfully!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back to doctor detail
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _cancelAppointment() {
    setState(() {
      selectedDate = null;
      selectedTime = null;
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment cancelled")),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter email";
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Enter a valid email address";
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Enter phone number";
    final phoneRegex = RegExp(r'^(03[0-9]{9})$');
    if (!phoneRegex.hasMatch(value)) return "Enter valid Pakistani number (e.g. 03001234567)";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.itemName} Appointment"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Booking for: ${widget.itemName}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Text("Consultation Fee: ${widget.itemPrice}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const Divider(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(selectedDate == null
                    ? "Select Appointment Date"
                    : "Date: ${selectedDate!.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today, color: Colors.teal),
                onTap: _selectDate,
              ),
              ListTile(
                title: Text(selectedTime == null
                    ? "Select Appointment Time"
                    : "Time: ${selectedTime!.format(context)}"),
                trailing: const Icon(Icons.access_time, color: Colors.teal),
                onTap: _selectTime,
              ),
              const SizedBox(height: 10),
              if (selectedDate != null && selectedTime != null)
                Column(
                  children: [
                    Text(
                      "Selected Appointment:\n${selectedDate!.toLocal().toString().split(' ')[0]} at ${selectedTime!.format(context)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _cancelAppointment,
                      child: const Text("Cancel Appointment",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _confirmAppointment,
                child: const Text("Confirm Appointment",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
