import 'package:flutter/material.dart';

import '../util/constants.dart';

class PsElevatedButtonIcon extends StatelessWidget {
  final bool isPrimary;
  final IconData icon;
  final String text;
  final Function() onTap;

  const PsElevatedButtonIcon({
    super.key,
    required this.isPrimary,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = isPrimary ? Colors.white : AppConstants.primaryColor;

    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: textColor),
      label: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? AppConstants.primaryColor : AppConstants.secondaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
      ),
    );
  }
}
