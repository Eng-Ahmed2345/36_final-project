// File: image_picker_page.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fetal_head_fixed/screens/UploadScreen.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  Uint8List? _imageBytes;
  File? _image;

  final Color iconColor = const Color(0xff49454f);

  final List<Map<String, String>> _measurementRows = const [
    {'ga': '20', 'bpd': '46–52', 'hc': '170–186'},
    {'ga': '24', 'bpd': '58–64', 'hc': '210–235'},
    {'ga': '28', 'bpd': '70–76', 'hc': '260–285'},
    {'ga': '32', 'bpd': '80–86', 'hc': '300–330'},
    {'ga': '36', 'bpd': '88–94', 'hc': '320–350'},
    {'ga': '40', 'bpd': '92–98', 'hc': '340–370'},
  ];

  void _showMeasurementDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Fetal Head Measurements',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _measurementRows.map((row) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Week ${row['ga']}'),
                      Text('BPD: ${row['bpd']} mm'),
                      Text('HC: ${row['hc']} mm'),
                      const Divider(height: 10),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: iconColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        _imageBytes = await pickedFile.readAsBytes();
      } else {
        _image = File(pickedFile.path);
        _imageBytes = await _image!.readAsBytes();
      }
      setState(() {});

      if (_imageBytes != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadImagePage(imageBytes: _imageBytes!),
          ),
        );
      }
    } else {
      debugPrint("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: iconColor,
        title: const Text(
          'Fetal Head',
          style: TextStyle(fontSize: 21, color: Colors.white),
        ),
        centerTitle: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                'Head Check',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'An app that helps with tracking fetal growth measurements such as head circumference (HC).',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: _showMeasurementDialog,
                  icon: const Icon(Icons.list),
                  label: const Text('View Measurements'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(6, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage('assets/fetal_head_$index.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.home, size: 25, color: iconColor),
                  onPressed: () {
                    // TODO: Handle navigation to home
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, size: 25, color: iconColor),
                  onPressed: _pickImage,
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
} 