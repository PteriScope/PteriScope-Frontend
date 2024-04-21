import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pteriscope_frontend/util/enum/dialog_type.dart';
import 'package:pteriscope_frontend/util/ps_exception.dart';
import 'package:pteriscope_frontend/widgets/ps_dialog.dart';

import '../screens/authentication/login_screen.dart';
import '../services/shared_preferences_service.dart';
import 'constants.dart';
import 'enum/snack_bar_type.dart';

class Shared {
  static Color getColorResult(String? result) {
    switch (result) {
      case AppConstants.noPterygium:
        {
          return AppConstants.normalColor;
        }
      case AppConstants.mildPterygium:
        {
          return AppConstants.mildColor;
        }
      case AppConstants.severePterygium:
        {
          return AppConstants.severeColor;
        }
      default:
        {
          return Colors.black;
        }
    }
  }

  static void logout(BuildContext context) {
    SharedPreferencesService().removeAuthToken();
    SharedPreferencesService().removeId();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  static void showPSSnackBar(
      BuildContext context, String message, SnackBarType type, int duration) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
            content: (type == SnackBarType.onlyText)
                ? Text(message)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(message),
                      const CircularProgressIndicator(),
                    ],
                  ),
            duration: Duration(seconds: duration)),
      );
  }

  static void showPsDialog(
      BuildContext context,
      DialogType dialogType,
      String content,
      String mainButtonText,
      Function() mainButtonAction,
      IconData mainButtonIcon,
      [String? secondaryButtonText,
      Function()? secondaryButtonAction,
      IconData? secondaryButtonIcon]) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PsDialog(
            dialogType: dialogType,
            content: content,
            mainButtonText: mainButtonText,
            mainButtonAction: mainButtonAction,
            mainButtonIcon: mainButtonIcon,
            secondaryButtonText: secondaryButtonText,
            secondaryButtonAction: secondaryButtonAction,
            secondaryButtonIcon: secondaryButtonIcon,
          );
        });
  }

  static Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw PsException("Verifique su conexión a Internet");
    } else {
      return true;
    }
  }

  static Future<bool> checkCameraPermission() async {
    var cameraStatus = await Permission.camera.status;
    return cameraStatus.isGranted;
  }
}
