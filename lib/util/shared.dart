import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/shared_preferences_service.dart';
import 'constants.dart';

class Shared{
  static Color getColorResult(String? result){
    switch(result){
      case AppConstants.noPterygium:{
        return AppConstants.normalColor;
      }
      case AppConstants.mildPterygium:{
        return AppConstants.mildColor;
      }
      case AppConstants.severePterygium:{
        return AppConstants.severeColor;
      }
      default: {
        return Colors.black;
      }
    }
  }

  static void logout(BuildContext context) {
    SharedPreferencesService().removeAuthToken();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen())
    );
  }
}