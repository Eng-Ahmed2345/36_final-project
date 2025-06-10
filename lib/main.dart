import 'package:flutter/material.dart';
import 'package:fetal_head_fixed/screens/HomeScreen.dart';
import 'package:fetal_head_fixed/screens/SplashScreen.dart';
import 'package:fetal_head_fixed/screens/Prediction.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
          '/home': (context) => const ImagePickerPage(),
          '/splash': (context) => const SplashScreen(),
      
        },
    );
  }
}