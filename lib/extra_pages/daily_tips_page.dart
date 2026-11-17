import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

class DailyTipsPage extends StatefulWidget {
  const DailyTipsPage({Key? key}) : super(key: key);

  @override
  _DailyTipsPageState createState() => _DailyTipsPageState();
}

class _DailyTipsPageState extends State<DailyTipsPage> {
  final List<String> tips = [
    "💧 Drink at least 8 glasses of water daily to stay hydrated.",
    "🚶 Walk at least 30 minutes every day to improve heart health.",
    "🥗 Eat more fruits and vegetables for a balanced diet.",
    "❌ Avoid junk food and sugary drinks for better fitness.",
    "😴 Get at least 7-8 hours of sleep every night.",
    "🧘‍♀️ Stretch your body every morning to improve flexibility.",
    "🧼 Wash your hands regularly to prevent infections.",
    "☕ Take breaks while working to reduce stress.",
    "🧠 Practice meditation for better mental health.",
    "👀 Limit screen time to protect your eyes.",
    "🍗 Include protein in every meal to build muscle.",
    "🚭 Avoid smoking and excessive alcohol consumption.",
    "☀️ Use sunscreen to protect your skin from UV rays.",
    "📖 Read something positive every morning.",
    "🧍 Keep your posture straight to avoid back pain.",
    "😂 Laugh often—it boosts immunity and mood.",
    "🧹 Keep your surroundings clean to prevent illness.",
    "🍽️ Eat slowly and mindfully to aid digestion.",
    "🌙 Avoid eating late at night.",
    "🌳 Spend time in nature to refresh your mind.",
    "💨 Practice deep breathing to reduce anxiety.",
    "🤝 Stay socially connected to improve emotional health.",
    "🚫 Avoid processed foods as much as possible.",
    "📝 Keep a gratitude journal.",
    "❤️ Do one act of kindness daily.",
    "🏥 Get regular health checkups.",
    "☕ Limit caffeine intake.",
    "👩‍🍳 Cook meals at home to control ingredients.",
    "🎵 Listen to calming music to relax.",
    "🧹 Declutter your space to reduce mental stress.",
    "🧘‍♂️ Do 10 minutes of stretching daily to reduce stiffness.",
    "🪜 Take stairs instead of elevators for better fitness.",
    "🍴 Eat smaller, frequent meals instead of heavy meals.",
    "🧂 Avoid too much salt—it can raise blood pressure.",
    "🐟 Eat foods rich in omega-3 fatty acids (like fish).",
    "🥩 Limit red meat; prefer lean protein like chicken or beans.",
    "🍬 Avoid too much sugar to prevent diabetes.",
    "👟 Wear comfortable shoes to protect your feet.",
    "🦷 Brush and floss daily for healthy teeth.",
    "🦷 Visit your dentist every 6 months.",
    "👁️ Do regular eye checkups to maintain vision.",
    "☀️ Spend at least 15 minutes in sunlight for Vitamin D.",
    "💪 Do regular physical exercise to strengthen your bones.",
    "🪑 Avoid sitting too long—stand up and stretch every hour.",
    "🧘 Practice yoga to improve flexibility and reduce stress.",
    "🥜 Eat nuts and seeds daily for healthy fats.",
    "🚭 Stay away from secondhand smoke.",
    "💉 Get vaccinated to prevent diseases.",
    "🚗 Always wear a seatbelt while driving.",
    "🍷 Limit alcohol to protect your liver.",
    "⚠️ Don’t ignore chest pain—seek medical help immediately.",
    "⚖️ Maintain a healthy body weight to prevent chronic illness.",
    "🖥️ Use correct posture while working on a computer.",
    "💊 Avoid overuse of painkillers—they can damage kidneys.",
    "💨 Do breathing exercises for lung health.",
    "🩺 Have routine blood pressure and sugar tests.",
    "📱 Keep emergency numbers saved in your phone.",
    "🌑 Sleep in a dark room to improve sleep quality."
  ];

  late String currentTip;
  late String currentEmoji;
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateRandomTip();
    _startAutoChange();
  }

  void _generateRandomTip() {
    setState(() {
      tips.shuffle();
      currentTip = tips.first;
      currentEmoji = currentTip.split(' ')[0]; // First emoji
    });
  }

  void _startAutoChange() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      _generateRandomTip();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Daily Health Tips"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Decorative Gradient + Shapes
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -50,
            left: -50,
            child: _buildDecorativeCircle(150, Colors.white24),
          ),
          Positioned(
            bottom: -80,
            right: -30,
            child: _buildDecorativeCircle(200, Colors.white30),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Container(
                      key: ValueKey<String>(currentTip),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          )
                        ],
                      ),
                      child: Text(
                        currentTip,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _generateRandomTip,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Show New Tip"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor: Colors.black87,
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      elevation: 8,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
