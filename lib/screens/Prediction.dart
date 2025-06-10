import 'dart:typed_data';
import 'package:flutter/material.dart';

class PredictionResultPage extends StatelessWidget {
  final Uint8List imageBytes;
  final String hc;
  final String bpd;
  final String ofd;

  const PredictionResultPage({
    super.key,
    required this.imageBytes,
    required this.hc,
    required this.bpd,
    required this.ofd,
  });

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Prediction Result'),
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0), // Reduced padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Analyzed Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15), // You can reduce these spacings too if needed
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(imageBytes, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Text('Head Circumference (HC): $hc', style: const TextStyle(fontSize: 16)),
            Text('Biparietal Diameter (BPD): $bpd', style: const TextStyle(fontSize: 16)),
            Text('Occipitofrontal Diameter (OFD): $ofd', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}
}