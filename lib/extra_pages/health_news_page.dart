import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  final List<Map<String, String>> newsList = const [
    {
      "title": "New Research on Heart Health",
      "description":
      "A recent study shows that walking 30 minutes daily reduces the risk of heart disease by 25%. Regular exercise can improve cardiovascular strength and overall health.",
      "date": "19 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/doctor-explaining-heart-model-patient_23-2149331093.jpg"
    },
    {
      "title": "Diabetes Awareness Campaign",
      "description":
      "Doctors suggest regular glucose monitoring, balanced diet, and proper medication to prevent diabetes-related complications.",
      "date": "18 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/doctor-holding-blood-sugar-device-patient_23-2149331099.jpg"
    },
    {
      "title": "COVID-19 Booster Updates",
      "description":
      "Health authorities recommend booster shots for elderly people and those with chronic illnesses to ensure better immunity.",
      "date": "16 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/doctor-injecting-vaccine-patient_23-2149331067.jpg"
    },
    {
      "title": "Mental Health Importance",
      "description":
      "Experts emphasize that meditation, proper sleep, and counseling improve emotional well-being and reduce stress.",
      "date": "15 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/psychologist-talking-with-patient_23-2149331125.jpg"
    },
    {
      "title": "Nutrition Tips for Kids",
      "description":
      "Pediatricians advise adding fresh fruits, vegetables, and milk to children’s diets for better immunity and growth.",
      "date": "14 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/little-girl-eating-fruits-vegetables_23-2149322010.jpg"
    },
    {
      "title": "Exercise Boosts Memory",
      "description":
      "Scientists reveal that regular workouts enhance brain activity, improving memory and learning skills in all age groups.",
      "date": "13 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/young-man-running-park_23-2149318821.jpg"
    },
    {
      "title": "Flu Season Precautions",
      "description":
      "Doctors urge people to get flu vaccines, wear masks in crowded areas, and maintain hand hygiene to avoid seasonal flu.",
      "date": "12 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/woman-wearing-mask-public-transport_23-2149331177.jpg"
    },
    {
      "title": "Cancer Awareness Drive",
      "description":
      "Oncologists stress regular screenings and early detection to improve survival chances in cancer treatment.",
      "date": "11 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/doctor-supporting-patient-hospital_23-2149331142.jpg"
    },
    {
      "title": "Healthy Sleep Patterns",
      "description":
      "Sleep specialists highlight that 7–8 hours of quality sleep is essential for heart health, mental focus, and immunity.",
      "date": "10 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/woman-sleeping-bed-night_23-2149321999.jpg"
    },
    {
      "title": "Hydration and Health",
      "description":
      "Medical experts recommend drinking at least 2–3 liters of water daily to prevent dehydration and improve metabolism.",
      "date": "09 Aug 2025",
      "image":
      "https://img.freepik.com/free-photo/young-woman-drinking-water-outdoor_23-2149321988.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Health News"),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Card(
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📰 News Image + Title
                    Stack(
                      children: [
                        Image.network(
                          news["image"]!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 12,
                          child: Text(
                            news["title"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 📝 News Description + Date
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news["description"]!,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "🗓 ${news["date"]}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
