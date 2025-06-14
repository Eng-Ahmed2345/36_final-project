import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'MedicalAdvice.dart';

class PredictionResultPage extends StatelessWidget {
  final Uint8List imageBytes;
  final String hc;
  final String bpd;
  final String ofd;
  final int week;

  const PredictionResultPage({
    super.key,
    required this.imageBytes,
    required this.hc,
    required this.bpd,
    required this.ofd,
    required this.week,
  });

  bool get isNormal {
    try {
      final double hcValue = double.tryParse(hc.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
      final double bpdValue = double.tryParse(bpd.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
      final double ofdValue = double.tryParse(ofd.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;

      return hcValue > 100 && bpdValue > 40 && ofdValue > 60;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0),
      appBar: AppBar(
        backgroundColor: const Color(0xff49454f),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Prediction Result',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Analyzed Ultrasound',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Image displayed fully without taking too much space
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black12,
                height: 200,
                width: double.infinity,
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Card with measurements
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gestational Week: $week', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Text('HC: $hc', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('BPD: $bpd', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('OFD: $ofd', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    Text(
                      isNormal
                          ? 'Measurements appear normal for week $week.'
                          : 'Measurements may be outside the normal range for week $week.',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: isNormal ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Advice button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("See Advice", style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff49454f),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdvicePage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
