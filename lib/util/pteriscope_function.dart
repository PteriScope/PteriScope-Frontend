import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/pteriscope_exception.dart';

enum SnackBarType {
  onlyText,
  loading
}

class PteriscopeFunction {

  static void PtriscopeSnackBar(BuildContext context, String message, SnackBarType type, int duration) {
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
          duration: Duration(seconds: duration)
      ),
    );
  }

  static Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw PteriscopeException("Verifique su conexión a Internet");
    } else {
      return true;
    }
  }

  //static void checkConnectivity() async {
  //  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  //  if (connectivityResult.contains(ConnectivityResult.none)) {
  //    throw PteriscopeException("Verifique su conexión a Internet");
  //  }
  //}
}