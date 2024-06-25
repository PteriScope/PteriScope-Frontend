import 'package:flutter/material.dart';

import '../util/constants.dart';

class PsElevatedButton extends StatelessWidget {
  final double width;
  final bool disabled;
  final Function()? onTap;
  final String text;
  final bool isSecondary;

  const PsElevatedButton({
    super.key,
    required this.width,
    required this.disabled,
    required this.onTap,
    required this.text,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: width,
      child: ElevatedButton(
        onPressed: disabled ? null : onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: isSecondary ? Colors.white : AppConstants.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text(
          text,
          style: TextStyle(color: isSecondary ? AppConstants.primaryColor : Colors.white),
        ),
      ),
    );
  }
}
