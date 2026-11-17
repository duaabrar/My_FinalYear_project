import 'package:flutter/material.dart';

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({Key? key}) : super(key: key);

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _bmi;
  String _resultText = "";
  String _healthTip = "";
  String _emoji = "";

  void _calculateBMI() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0) {
      final double bmi = weight / ((height / 100) * (height / 100));

      String category;
      String tip;
      String emoji;

      if (bmi < 18.5) {
        category = "Underweight";
        tip = "🍲 Eat nutrient-rich foods and consult a dietitian.";
        emoji = "🥗";
      } else if (bmi < 24.9) {
        category = "Normal weight";
        tip = "💪 Maintain your healthy lifestyle!";
        emoji = "😃";
      } else if (bmi < 29.9) {
        category = "Overweight";
        tip = "🏃 Exercise regularly and eat balanced meals.";
        emoji = "🏃";
      } else {
        category = "Obese";
        tip = "⚠️ Consult a doctor and adopt a weight-loss plan.";
        emoji = "🚨";
      }

      setState(() {
        _bmi = bmi;
        _resultText = "BMI: ${bmi.toStringAsFixed(1)}\nCategory: $category";
        _healthTip = tip;
        _emoji = emoji;
      });
    } else {
      setState(() {
        _resultText = "⚠️ Please enter valid height and weight!";
        _healthTip = "";
        _bmi = null;
        _emoji = "";
      });
    }
  }

  void _resetFields() {
    _heightController.clear();
    _weightController.clear();
    setState(() {
      _bmi = null;
      _resultText = "";
      _healthTip = "";
      _emoji = "";
    });
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24.9) return Colors.green;
    if (bmi < 29.9) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Animated Icon Header
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.monitor_heart,
                          size: 80, color: Colors.white.withOpacity(0.9)),
                      const SizedBox(height: 10),
                      const Text(
                        "Check Your BMI",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Stay healthy and track your body mass index easily",
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Glassmorphism Card for inputs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Height (cm)",
                            labelStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.height,
                                color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Weight (kg)",
                            labelStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(Icons.monitor_weight,
                                color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _calculateBMI,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.tealAccent[700],
                                ),
                                child: const Text(
                                  "Calculate",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: _resetFields,
                              icon: const Icon(Icons.refresh,
                                  size: 30, color: Colors.redAccent),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Result Section with animation
                if (_resultText.isNotEmpty)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _emoji,
                          style: const TextStyle(fontSize: 50),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _resultText,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),

                        if (_bmi != null)
                          LinearProgressIndicator(
                            value: (_bmi! / 40).clamp(0.0, 1.0),
                            color: _getBMIColor(_bmi!),
                            backgroundColor: Colors.grey[300],
                            minHeight: 12,
                          ),

                        const SizedBox(height: 15),

                        Text(
                          _healthTip,
                          style: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
