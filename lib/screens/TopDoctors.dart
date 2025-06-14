import 'package:flutter/material.dart';

class TopDoctorsPage extends StatelessWidget {
  const TopDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> doctors = [
      {
        'name': 'Dr. Amina Saleh',
        'specialty': 'Prenatal Imaging Specialist',
        'hospital': 'Future Mothers Clinic',
        'image': 'assets/images/doctor1.png'
      },
      {
        'name': 'Dr. Khaled Mansour',
        'specialty': 'Fetal Medicine Consultant',
        'hospital': 'New Life Hospital',
        'image': 'assets/images/doctor2.png'
      },
      {
        'name': 'Dr. Lina Hassan',
        'specialty': 'Obstetrics & Gynecology',
        'hospital': 'Healthy Family Center',
        'image': 'assets/images/doctor3.png'
      },
      {
        'name': 'Dr. Yusuf El-Sayed',
        'specialty': 'Neonatal & Fetal Care',
        'hospital': 'CureHope Hospital',
        'image': 'assets/images/doctor4.png'
      },
         {
    'name': 'Prof. Kypros Nicolaides',
    'specialty': 'Fetal Medicine Pioneer',
    'hospital': 'King’s College Hospital, London',
    'image': 'assets/images/kypros_nicolaides.png'
  },
  {
    'name': 'Dr. Beryl Benacerraf',
    'specialty': 'Prenatal Ultrasound Specialist',
    'hospital': 'Harvard Medical School',
    'image': 'assets/images/beryl_benacerraf.png'
  },
  {
    'name': 'Prof. Aris Papageorghiou',
    'specialty': 'Maternal-Fetal Medicine Expert',
    'hospital': 'University of Oxford',
    'image': 'assets/images/aris_papageorghiou.png'
  },
  {
    'name': 'Dr. N. Scott Adzick',
    'specialty': 'Fetal Surgery Specialist',
    'hospital': 'Children’s Hospital of Philadelphia',
    'image': 'assets/images/scott_adzick.png'
  },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
  'Top Doctors',
  style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  ),
),

        backgroundColor: Color(0xff49454f),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  doctor['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
              ),
              title: Text(
                doctor['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor['specialty']!),
                  Text(doctor['hospital']!),
                ],
              ),
              
            ),
          );
        },
      ),
    );
  }
} 