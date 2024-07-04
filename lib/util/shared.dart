import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pteriscope_frontend/util/enum/dialog_type.dart';
import 'package:pteriscope_frontend/util/enum/ps_font_type.dart';
import 'package:pteriscope_frontend/util/enum/ps_font_weight.dart';
import 'package:pteriscope_frontend/util/ps_exception.dart';
import 'package:pteriscope_frontend/widgets/ps_dialog.dart';

import '../screens/authentication/login_screen.dart';
import '../services/shared_preferences_service.dart';
import 'constants.dart';
import 'enum/button_type.dart';
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
          return AppConstants.greyColor;
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
        barrierDismissible: false,
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

  static double psFontSize(double figmaFont,
      [PsFontType fontType = PsFontType.roboto,
      PsFontWeight psFontWeight = PsFontWeight.bold]) {
    final double finalFont;
    switch (fontType) {
      case PsFontType.roboto:
        switch (psFontWeight) {
          case PsFontWeight.bold:
            finalFont = figmaFont + 2;
          case PsFontWeight.semibold:
            finalFont = figmaFont + 0.8;
          case PsFontWeight.regular:
            finalFont = figmaFont + 2;
          case PsFontWeight.medium:
            finalFont = figmaFont;
        }
      case PsFontType.inter:
        finalFont = figmaFont + 1.5;
      case PsFontType.sfProText:
        switch (psFontWeight) {
          case PsFontWeight.bold:
            finalFont = figmaFont;
          case PsFontWeight.semibold:
            finalFont = figmaFont + 1.6;
          case PsFontWeight.regular:
            finalFont = figmaFont;
          case PsFontWeight.medium:
            finalFont = figmaFont + 1.6;
        }
    }
    return finalFont;
  }

  static Color getButtonBackgroundColor(ButtonType buttonType) {
    if (buttonType == ButtonType.primary) {
      return AppConstants.primaryColor;
    }
    if (buttonType == ButtonType.secondary) {
      return AppConstants.secondaryColor;
    }
    if (buttonType == ButtonType.severe) {
      return AppConstants.redIconColor;
    } else {
      return Colors.white;
    }
  }

  static Color getButtonTextColor(ButtonType buttonType) {
    if (buttonType == ButtonType.primary || buttonType == ButtonType.severe) {
      return Colors.white;
    }
    if (buttonType == ButtonType.secondary) {
      return AppConstants.primaryColor;
    } else {
      return Colors.black;
    }
  }
}
