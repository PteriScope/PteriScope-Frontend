import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';

import '../util/constants.dart';
import '../util/shared.dart';
import 'authentication/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: AppConstants.splashDelay), () {});

    bool isLoggedIn = await SharedPreferencesService().isLogged();
    if (isLoggedIn) {
      //Shared.logout(context);
    } else {
      //Navigator.of(context).pushReplacement(
      //    MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 100,),
            Image(
              image: AssetImage('assets/newLogo_bw.png'),
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: AppConstants.padding),
              child: Text('PteriScope',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
          ],
        ),
      ),
      backgroundColor: AppConstants.secondaryColor,
    );
  }
}
