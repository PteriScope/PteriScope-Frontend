import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/constants.dart';
import 'package:pteriscope_frontend/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PteriScope',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppConstants.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
