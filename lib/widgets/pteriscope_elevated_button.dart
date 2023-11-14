import 'package:flutter/material.dart';

import '../util/constants.dart';

class PteriscopeElevatedButton extends StatelessWidget {
  final double width;
  final bool enabled;
  final Function()? onTap;
  final String text;

  const PteriscopeElevatedButton({
    super.key,
    required this.width,
    required this.enabled,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: width,
      child: ElevatedButton(
        onPressed: enabled ? null : onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
