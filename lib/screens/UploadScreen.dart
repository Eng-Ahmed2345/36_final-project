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

  int selectedWeek = 20; // default selected gestational week
  final List<int> gestationalWeeks = List.generate(31, (index) => 12 + index); // Weeks 12–42

  Future<void> _sendImage() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final uri = Uri.parse('http://127.0.0.1:5000/process-image'); // Update this for your backend

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
        try {
          final data = json.decode(response.body);

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
                  week: selectedWeek,
                ),
              ),
            );
          } else {
            setState(() => error = 'No image field found in the response.');
          }
        } catch (_) {
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
                  week: selectedWeek,
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
            const SizedBox(height: 30),
            Image.memory(widget.imageBytes, height: 145),
            const SizedBox(height: 20),

            // Gestational week dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Gestational Week",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedWeek,
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        items: gestationalWeeks.map((week) {
                          return DropdownMenuItem<int>(
                            value: week,
                            child: Text("Week $week"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWeek = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
