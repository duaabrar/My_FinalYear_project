import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiKey = "MY_API_KEY";

  // Predefined fallback responses
  final Map<String, String> fallbackResponses = {
    "hii": "👋 Hello! How can I assist you with your health today?",
    "hello": "Hi there! 😊 I'm your healthcare assistant.",
    "hey": "Hey! 😃 How are you feeling today?",
    "good morning": "☀️ Good morning! Ready for a healthy day?",
    "good evening": "🌇 Good evening! How was your day?",
    "good night": "🌙 Good night! Make sure to rest well.",
    "how are you": "I'm an AI assistant 🤖, but I'm here to help you!",
    "greetings": "Greetings! 🙌 How can I help you stay healthy?",
    "hiya": "Hi! 🩺 Need any health tips today?",
    "hola": "Hello! 🌟 I'm your friendly health assistant.",

    // Doctor suggestions
    "doctor": "You can consult a Family Doctor, Gynecologist, or Neurologist depending on your needs.",
    "family doctor": "A Family Doctor can help with general checkups and minor illnesses.",
    "gynecologist": "Gynecologists specialize in women's health issues.",
    "neurologist": "Neurologists help with nervous system problems.",
    "pediatrician": "Pediatricians specialize in children's health.",
    "cardiologist": "Cardiologists handle heart-related issues.",
    "dermatologist": "Dermatologists treat skin conditions.",
    "dentist": "Dentists take care of your teeth and oral health.",
    "orthopedic": "Orthopedic doctors help with bones and joints.",
    "psychiatrist": "Psychiatrists help with mental health issues.",
    "ent": "ENT specialists handle ear, nose, and throat problems.",
    "ophthalmologist": "Ophthalmologists care for your eyes.",
    "urologist": "Urologists treat urinary and kidney issues.",
    "nutritionist": "Nutritionists guide you about healthy eating.",
    "physiotherapist": "Physiotherapists help recover mobility after injuries.",

    // Patient illness statements
    "i am ill": "🤒 I'm sorry to hear that. Can you describe your symptoms?",
    "i am sick": "😔 Oh no! Please tell me more about how you are feeling.",
    "i have high fever": "🌡️ A fever may indicate an infection. Rest and hydrate well.",
    "i am suffering from high fever": "🥵 Take plenty of fluids and consult a doctor if the fever persists.",
    "i have headache": "🤕 Headaches can be caused by stress, dehydration, or vision problems. Drink water and rest.",
    "i feel dizzy": "💫 Dizziness may indicate low blood pressure or dehydration. Sit down and relax.",
    "i have stomachache": "🤢 Stomach pain can result from indigestion. Eat light meals and drink water.",
    "i feel nauseous": "🤮 Nausea may be due to stomach upset. Ginger tea can help.",
    "i have cough": "🤧 Coughs may be viral or bacterial. Rest and stay hydrated.",
    "i have sore throat": "😷 Gargle warm salt water and drink soothing fluids.",

    // Emergency & general advice
    "emergency": "🚨 In case of emergency, call your local emergency number immediately.",
    "accident": "🏥 Seek medical attention immediately if injured.",
    "poison": "☠️ Contact poison control center immediately.",
    "bleeding": "🩸 Apply pressure and seek medical help for severe bleeding.",
    "fracture": "🦴 Immobilize the area and visit a doctor.",
    "choking": "🤏 Perform Heimlich maneuver if someone is choking.",
    "heart attack": "❤️ Call emergency services immediately if chest pain occurs.",
    "stroke": "⚠️ Seek emergency care immediately if stroke symptoms appear.",
    "pregnancy": "🤰 Consult a gynecologist for pregnancy care.",
    "child care": "👶 Ensure vaccinations and regular pediatric checkups.",
    "mental support": "🧠 Talk to friends or counselors for mental well-being.",
    "allergy": "🌸 Avoid allergens and consult a doctor if symptoms persist.",
    "infection": "🧼 Keep affected area clean and see a doctor if severe.",
  };

  // Expanded home remedies with symbols
  final List<String> homeRemedies = [
    "🍯 Drink warm water with honey and lemon.",
    "🍵 Try ginger tea for nausea or cold.",
    "💧 Rest and stay hydrated.",
    "♨️ Apply a warm compress to sore muscles.",
    "🥗 Eat light, nutritious meals.",
    "🚶 Take a short walk to improve circulation.",
    "🧘 Practice deep breathing or meditation to reduce stress.",
    "💨 Use steam inhalation for congestion.",
    "🌿 Drink herbal teas like chamomile or peppermint.",
    "🧼 Maintain good hygiene and wash hands frequently.",
    "🌞 Get some sunlight for vitamin D.",
    "🛌 Take a short nap if feeling fatigued.",
    "🥛 Drink milk for stomach comfort or bone strength.",
    "🧊 Use ice packs for minor swelling.",
    "🍵 Drink warm turmeric milk for immunity.",
    "🥒 Apply cucumber slices on eyes to reduce puffiness.",
    "🫖 Sip lemon-ginger-honey tea for sore throat.",
    "🧂 Gargle warm salt water for throat irritation.",
    "🥤 Take electrolyte drinks if dehydrated.",
    "🍎 Eat fruits rich in vitamin C.",
    "🧄 Use garlic in meals to boost immunity.",
    "🥑 Include healthy fats like avocado for nutrition.",
    "🛀 Take warm baths to relax muscles.",
    "🫗 Drink water with a pinch of salt for mild dehydration.",
    "🧈 Use coconut oil for skin hydration.",
    "🌱 Chew fresh mint leaves for mild stomach upset.",
    "🍌 Eat bananas for mild diarrhea or low energy.",
    "🥕 Eat carrots for better eyesight and immunity.",
    "🥤 Sip chamomile tea to improve sleep.",
    "🧄 Apply honey on minor cuts for antiseptic effect.",
    "🥛 Drink kefir or yogurt for gut health.",
    "🫚 Use ginger compress for muscle pain.",
    "🥗 Eat fiber-rich meals to improve digestion.",
    "🛏️ Sleep 7-8 hours to improve recovery.",
    "🍃 Breathe fresh air to reduce stress.",
    "🧊 Cool compress for mild headaches.",
    "🫙 Use aloe vera gel for minor burns or skin irritation.",
    "🥤 Stay hydrated with water every 1-2 hours.",
    "🌾 Eat oatmeal for stomach comfort.",
    "🍯 Mix honey and cinnamon for immunity boost.",
    "🧂 Avoid excess salt to reduce bloating.",
    "🌽 Eat whole grains for energy.",
    "🥛 Drink milk with turmeric for cold relief.",
    "🥄 Consume probiotics for digestion.",
    "🫐 Eat berries for antioxidants.",
    "🫖 Herbal steam inhalation for sinus relief.",
    "🛁 Soak feet in warm water to relax before sleep.",
    "🥒 Apply potato slices for eye puffiness.",
    "🍋 Drink warm lemon water in the morning.",
    "🫖 Drink peppermint tea for digestion."
  ];

  final Random _random = Random();

  Future<String> getResponse(String userMessage) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": "You are a friendly healthcare assistant. Answer health questions, greet the user, suggest doctors, and provide home remedies if asked."
            },
            {"role": "user", "content": userMessage}
          ],
          "max_tokens": 200,
          "temperature": 0.7
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String answer = data['choices'][0]['message']['content'].toString().trim();
        if (answer.isEmpty) return _fallback(userMessage);
        return answer;
      } else {
        return _fallback(userMessage);
      }
    } catch (e) {
      return _fallback(userMessage);
    }
  }

  String _fallback(String userMessage) {
    String message = userMessage.toLowerCase();

    // 1. Exact match
    if (fallbackResponses.containsKey(message)) {
      return fallbackResponses[message]!;
    }

    // 2. Partial keyword match
    for (var key in fallbackResponses.keys) {
      if (message.contains(key.toLowerCase())) {
        return fallbackResponses[key]!;
      }
    }

    // 3. Word-level matching
    List<String> words = message.split(RegExp(r'\s+'));
    for (var key in fallbackResponses.keys) {
      List<String> keyWords = key.toLowerCase().split(' ');
      bool match = keyWords.every((kw) => words.contains(kw));
      if (match) return fallbackResponses[key]!;
    }

    // 4. Default: Return random home remedy
    return homeRemedies[_random.nextInt(homeRemedies.length)];
  }
}
