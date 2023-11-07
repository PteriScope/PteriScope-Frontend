import 'package:flutter/material.dart';

import '../constants.dart';
import '../services/authentication_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: AppConstants.splashDelay), () {});

    bool isLoggedIn = await AuthenticationService().checkLoggedInStatus();
    bool isLoggedIn = false;
    if (isLoggedIn) {
      // Navigate to HomeScreen
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/Logo_w.png'),
              height: 100,
            ),
            SizedBox(height: 10),
            Text(
                'PteriScope',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                )
            ),
          ],
        ),
      ),
    );
  }
}
