import 'package:flutter/material.dart';

import '../util/constants.dart';

class PsElevatedButton extends StatelessWidget {
  final double width;
  final bool disabled;
  final Function()? onTap;
  final String text;

  const PsElevatedButton({
    super.key,
    required this.width,
    required this.disabled,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: width,
      child: ElevatedButton(
        onPressed: disabled ? null : onTap,
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
