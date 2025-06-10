import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Prediction.dart'; // Import your prediction page

class UploadImagePage extends StatefulWidget {
  final Uint8List imageBytes;

  const UploadImagePage({super.key, required this.imageBytes});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  bool loading = false;
  String? error;

  Future<void> _sendImage() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      // Change the URI to your Flask server IP or use 10.0.2.2 for Android emulator
      final uri = Uri.parse('http://192.168.1.5:5000/process-image');//http://10.0.2.2:5000 for emulator android


      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile.fromBytes(
            'image',
            widget.imageBytes,
            filename: 'image.jpg',
          ),
        );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        // Attempt to parse JSON first
        try {
          final data = json.decode(response.body);

          // Correct measurement keys
          final base64Image = data['image'] as String?;
          final hc = data['HC'] ?? 'HC: N/A';
          final bpd = data['BPD'] ?? 'BPD: N/A';
          final ofd = data['OFD'] ?? 'OFD: N/A';

          if (base64Image != null) {
            final Uint8List processed = base64Decode(base64Image);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PredictionResultPage(
                  imageBytes: processed,
                  hc: hc,
                  bpd: bpd,
                  ofd: ofd,
                ),
              ),
            );
          } else {
            setState(() => error = 'No image field found in the response.');
          }
        } catch (_) {
          // If JSON parsing fails, assume raw image bytes
          final bytes = response.bodyBytes;
          if (bytes.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PredictionResultPage(
                  imageBytes: bytes,
                  hc: 'HC: N/A',
                  bpd: 'BPD: N/A',
                  ofd: 'OFD: N/A',
                ),
              ),
            );
          } else {
            setState(() => error = 'Received empty image data.');
          }
        }
      } else {
        setState(() => error =
            'Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() => error = 'Connection failed: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Head Check',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upload and analyze fetal head measurement.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Image.memory(widget.imageBytes, height: 145),
            const Spacer(),

            if (loading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
            ] else if (error != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 20),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.cloud_upload, size: 30),
                  onPressed: loading ? null : _sendImage,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}