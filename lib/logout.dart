import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  // Purani sari screens clear karke LoginPage par bhejna
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
  );

  // Optional: Snackbar message
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("You have been logged out")),
  );
}
