import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/enum/button_type.dart';

import '../util/constants.dart';

class PsFloatingButton extends StatelessWidget {
  final String heroTag;
  final ButtonType buttonType;
  final Function() onTap;
  final IconData iconData;
  final bool? disabled;

  const PsFloatingButton({
    super.key,
    required this.heroTag,
    required this.buttonType,
    required this.onTap,
    required this.iconData,
    this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: _getButtonBackgroundColor(buttonType),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Icon(iconData, color: _getButtonTextColor(buttonType)),
      mini: true,
    );
  }

  Color _getButtonBackgroundColor(ButtonType buttonType) {
    if (buttonType == ButtonType.primary) {
      return AppConstants.primaryColor;
    }
    if (buttonType == ButtonType.secondary) {
      return AppConstants.secondaryColor;
    }
    if (buttonType == ButtonType.severe) {
      return AppConstants.severeColor;
    } else {
      return Colors.white;
    }
  }

  Color _getButtonTextColor(ButtonType buttonType) {
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
