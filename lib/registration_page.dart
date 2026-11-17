import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  void _registerUser() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _isLoading = true;
    });

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    bool hasError = false;

    // Name validation
    if (name.isEmpty) {
      _nameError = "Name is required.";
      hasError = true;
    } else if (!RegExp(r"^[A-Za-z][A-Za-z ]*$").hasMatch(name)) {
      _nameError = "Name must start with a letter and only allow spaces inside.";
      hasError = true;
    }

    // Email validation
    if (email.isEmpty) {
      _emailError = "Email is required.";
      hasError = true;
    } else if (!email.endsWith("@gmail.com") || !email.contains('@')) {
      _emailError = "Email must be valid and end with @gmail.com";
      hasError = true;
    }

    // Password validation
    if (password.isEmpty) {
      _passwordError = "Password is required.";
      hasError = true;
    } else if (password.length < 8 || password.length > 15) {
      _passwordError = "Password must be between 8 and 15 characters.";
      hasError = true;
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,15}$')
        .hasMatch(password)) {
      _passwordError =
      "Password must include uppercase, lowercase, number & special char.";
      hasError = true;
    }

    if (hasError) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Check if name already exists
      final nameCheck =
      await _firestore.collection('users').where('name', isEqualTo: name).get();

      if (nameCheck.docs.isNotEmpty) {
        setState(() {
          _nameError = "Name is already taken.";
          _isLoading = false;
        });
        return;
      }

      // Proceed with registration
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': Timestamp.now(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _emailError = "Email is already in use.";
        } else if (e.code == 'weak-password') {
          _passwordError = "Password is too weak.";
        } else {
          _passwordError = "Registration failed. Please try again.";
        }
      });
    } catch (e) {
      setState(() {
        _passwordError = "Unexpected error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // prevents jumpy screen
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Register Account",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(_nameController, "Name", errorText: _nameError,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z ]")),
                        ]),
                    _buildInputField(_emailController, "Email", errorText: _emailError,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s"))
                        ]),
                    _buildPasswordField(),
                    if (_passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _passwordError!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: const Text(
                        "Register",
                        style:
                        TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?",
                            style: TextStyle(fontSize: 16)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {List<TextInputFormatter>? inputFormatters, String? errorText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        inputFormatters: [LengthLimitingTextInputFormatter(15)],
        decoration: InputDecoration(
          labelText: "Password",
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.deepPurple,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
    );
  }
}
