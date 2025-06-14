// ignore_for_file: unused_element

import 'package:flutter/material.dart';

class AdvicePage extends StatelessWidget {
  const AdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Advice & Guidance',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xff49454f),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          _buildAdviceSection(
              "Hydrocephalus",
              "Hydrocephalus is an abnormal buildup of fluid in the brain. If your scan indicates this condition, follow up frequently with your doctor. Signs may include rapid head growth. Early treatment such as surgery (shunt placement) can help manage it.",
              "assets/adv1.jpg"),
          _buildAdviceSection(
              "Microcephaly",
              "Microcephaly refers to a smaller-than-average head size, which may suggest underdeveloped brain growth. Ensure consistent prenatal care, proper maternal nutrition, and request developmental follow-up after birth.",
              "assets/adv2.jpg"),
          _buildAdviceSection(
              "Asymmetric Growth",
              "This means the head dimensions are not developing evenly. Causes may include restricted fetal growth or twin pregnancy. Keep detailed records of your scans and discuss with your physician about the underlying reason.",
              "assets/adv3.jpg"),
          _buildAdviceSection(
              "Normal Scan Results",
              "If everything appears normal, maintain your regular prenatal visits, follow a healthy lifestyle, and take any supplements prescribed by your doctor. Continue monitoring fetal development as advised.",
              "assets/adv4.jpg"),
          _buildAdviceSection(
              "Emotional & Lifestyle Advice",
              "- Attend all scheduled appointments even if previous scans are normal.\n- Reduce stress through light activities, breathing exercises, or talking with a counselor.\n- Join prenatal classes or mother support groups.\n- Keep a diary of symptoms, emotions, and scan updates.\n- Ask your doctor anything you're unsure about.",
              "assets/adv5.jpg"),
          const SizedBox(height: 30),
          _buildNavigationButtons(context),
        ],
      ),
    );
  }

  Widget _buildAdviceSection(String title, String content, String assetPath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                assetPath,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child:
                          Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff49454f)),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff49454f),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Back',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/doctors');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff49454f),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Next',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }
}