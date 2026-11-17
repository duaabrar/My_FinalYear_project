import 'package:flutter/material.dart';

class SymptomGuideScreen extends StatefulWidget {
  @override
  _SymptomGuideScreenState createState() => _SymptomGuideScreenState();
}

class _SymptomGuideScreenState extends State<SymptomGuideScreen> {
  final List<Map<String, String>> symptoms = [
    // Family Doctor (10)
    {"symptom": "Fever", "advice": "1. Drink plenty of water.\n2. Take rest.\n3. Monitor temperature.\n4. If >3 days, see doctor.\n5. Use paracetamol if needed.", "doctor": "Family Doctor"},
    {"symptom": "Flu", "advice": "1. Take warm fluids.\n2. Rest adequately.\n3. Take Vitamin C.\n4. Avoid cold.\n5. Consult doctor if worsens.", "doctor": "Family Doctor"},
    {"symptom": "Fatigue", "advice": "1. Sleep 7-8 hours.\n2. Balanced diet.\n3. Hydrate.\n4. Take breaks.\n5. Consult doctor if persistent.", "doctor": "Family Doctor"},
    {"symptom": "Cough", "advice": "1. Drink warm water.\n2. Steam inhalation.\n3. Avoid smoke.\n4. Use cough syrup.\n5. See doctor if >2 weeks.", "doctor": "Family Doctor"},
    {"symptom": "Vomiting", "advice": "1. Stay hydrated.\n2. Avoid oily foods.\n3. Rest.\n4. Eat light meals.\n5. See doctor if >24h.", "doctor": "Family Doctor"},
    {"symptom": "Diarrhea", "advice": "1. Drink ORS.\n2. Avoid fatty food.\n3. Rest.\n4. Eat light meals.\n5. Seek doctor if severe.", "doctor": "Family Doctor"},
    {"symptom": "Sore Throat", "advice": "1. Gargle warm salt water.\n2. Drink warm fluids.\n3. Avoid irritants.\n4. Take rest.\n5. See doctor if persistent.", "doctor": "Family Doctor"},
    {"symptom": "Cold", "advice": "1. Rest.\n2. Warm fluids.\n3. Avoid cold exposure.\n4. Take vitamins.\n5. Consult doctor if fever develops.", "doctor": "Family Doctor"},
    {"symptom": "Skin Rash", "advice": "1. Avoid scratching.\n2. Clean area.\n3. Apply mild lotion.\n4. Avoid irritants.\n5. See doctor if spreads.", "doctor": "Family Doctor"},
    {"symptom": "Allergy", "advice": "1. Identify trigger.\n2. Avoid allergens.\n3. Take antihistamines.\n4. Keep environment clean.\n5. Consult doctor if severe.", "doctor": "Family Doctor"},

    // Cardiologist (5)
    {"symptom": "Chest Pain", "advice": "1. Sit and rest.\n2. Avoid stress.\n3. Seek emergency help if severe.\n4. Monitor symptoms.\n5. Consult cardiologist.", "doctor": "Cardiologist"},
    {"symptom": "High Blood Pressure", "advice": "1. Reduce salt.\n2. Exercise moderately.\n3. Monitor BP.\n4. Avoid stress.\n5. Consult cardiologist.", "doctor": "Cardiologist"},
    {"symptom": "Low Blood Pressure", "advice": "1. Drink fluids.\n2. Avoid sudden standing.\n3. Eat small meals.\n4. Rest when dizzy.\n5. Consult cardiologist.", "doctor": "Cardiologist"},
    {"symptom": "Shortness of Breath", "advice": "1. Sit upright.\n2. Get fresh air.\n3. Avoid exertion.\n4. Monitor chest pain.\n5. Consult doctor if severe.", "doctor": "Cardiologist"},
    {"symptom": "Palpitations", "advice": "1. Reduce stress.\n2. Avoid caffeine.\n3. Monitor heartbeat.\n4. Note triggers.\n5. Consult cardiologist if persistent.", "doctor": "Cardiologist"},

    // Dentist (5)
    {"symptom": "Toothache", "advice": "1. Warm salt-water gargle.\n2. Apply clove oil.\n3. Avoid hard foods.\n4. Maintain hygiene.\n5. Visit dentist.", "doctor": "Dentist"},
    {"symptom": "Gum Pain", "advice": "1. Soft brush.\n2. Gargle warm water.\n3. Avoid sticky foods.\n4. Maintain oral hygiene.\n5. Consult dentist.", "doctor": "Dentist"},
    {"symptom": "Cracked Tooth", "advice": "1. Avoid hard foods.\n2. Rinse mouth.\n3. Apply cold compress.\n4. Keep tooth clean.\n5. Visit dentist immediately.", "doctor": "Dentist"},
    {"symptom": "Sensitivity", "advice": "1. Use sensitivity toothpaste.\n2. Avoid hot/cold food.\n3. Brush gently.\n4. Maintain oral hygiene.\n5. See dentist if persistent.", "doctor": "Dentist"},
    {"symptom": "Bad Breath", "advice": "1. Brush regularly.\n2. Use mouthwash.\n3. Stay hydrated.\n4. Avoid pungent foods.\n5. Dental cleaning regularly.", "doctor": "Dentist"},

    // Neurologist (5)
    {"symptom": "Headache", "advice": "1. Rest.\n2. Avoid caffeine.\n3. Stay hydrated.\n4. Reduce stress.\n5. Consult neurologist if persistent.", "doctor": "Neurologist"},
    {"symptom": "Dizziness", "advice": "1. Stay hydrated.\n2. Avoid sudden standing.\n3. Rest when needed.\n4. Monitor blood pressure.\n5. Consult neurologist if frequent.", "doctor": "Neurologist"},
    {"symptom": "Memory Loss", "advice": "1. Improve sleep.\n2. Manage stress.\n3. Mental exercises.\n4. Maintain diet.\n5. Consult neurologist if persistent.", "doctor": "Neurologist"},
    {"symptom": "Migraine", "advice": "1. Rest in dark room.\n2. Avoid loud noise.\n3. Monitor triggers.\n4. Stay hydrated.\n5. Consult neurologist.", "doctor": "Neurologist"},
    {"symptom": "Depression/Anxiety", "advice": "1. Exercise daily.\n2. Meditation or breathing exercises.\n3. Social support.\n4. Monitor symptoms.\n5. Consult neurologist if severe.", "doctor": "Neurologist"},

    // Orthopedic (5)
    {"symptom": "Joint Pain", "advice": "1. Rest affected joint.\n2. Apply warm compress.\n3. Avoid overexertion.\n4. Gentle exercise if allowed.\n5. Consult orthopedic doctor.", "doctor": "Orthopedic"},
    {"symptom": "Back Pain", "advice": "1. Maintain posture.\n2. Avoid heavy lifting.\n3. Gentle stretching.\n4. Use ergonomic seating.\n5. Consult orthopedic doctor.", "doctor": "Orthopedic"},
    {"symptom": "Fracture", "advice": "1. Immobilize affected area.\n2. Avoid movement.\n3. Apply cold compress.\n4. Get X-ray.\n5. Consult orthopedic immediately.", "doctor": "Orthopedic"},
    {"symptom": "Muscle Strain", "advice": "1. Rest the muscle.\n2. Apply ice packs.\n3. Avoid overuse.\n4. Gentle stretching after 24h.\n5. See orthopedic if pain persists.", "doctor": "Orthopedic"},
    {"symptom": "Heel/Foot Pain", "advice": "1. Wear comfortable shoes.\n2. Avoid prolonged standing.\n3. Gentle stretching.\n4. Rest when needed.\n5. Consult orthopedic if persistent.", "doctor": "Orthopedic"},
  ];

  String? selectedSymptom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Symptom-to-Care Guide"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Your Symptom",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Get professional advice and recommended doctor",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Symptom List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                var item = symptoms[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSymptom = item["symptom"];
                    });
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: Icon(Icons.health_and_safety, color: Colors.teal),
                      title: Text(
                        item["symptom"]!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.teal, size: 18),
                    ),
                  ),
                );
              },
            ),
          ),

          // Advice Section
          if (selectedSymptom != null)
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal.shade100),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedSymptom!,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  SizedBox(height: 12),
                  Text(
                    symptoms
                        .firstWhere((s) => s["symptom"] == selectedSymptom)["advice"]!,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.local_hospital, color: Colors.red, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "Doctor: ${symptoms.firstWhere((s) => s["symptom"] == selectedSymptom)["doctor"]!}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent),
                      ),
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
