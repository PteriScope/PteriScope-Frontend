import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/enum/button_type.dart';
import 'package:pteriscope_frontend/util/enum/ps_font_type.dart';
import 'package:pteriscope_frontend/util/shared.dart';

import '../util/constants.dart';

class PsElevatedButton extends StatelessWidget {
  final double width;
  final bool disabled;
  final Function()? onTap;
  final String text;
  final ButtonType buttonType;

  const PsElevatedButton({
    super.key,
    required this.width,
    required this.disabled,
    required this.onTap,
    required this.text,
    this.buttonType = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: width,
      child: ElevatedButton(
        onPressed: disabled ? null : onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: Shared.getButtonBackgroundColor(buttonType),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Text(
          text,
          style: TextStyle(
              color: Shared.getButtonTextColor(buttonType),
              fontSize: Shared.psFontSize(16, PsFontType.inter)),
        ),
      ),
    );
  }
}
