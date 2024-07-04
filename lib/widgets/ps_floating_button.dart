import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/enum/button_type.dart';

import '../util/constants.dart';
import '../util/shared.dart';

class PsFloatingButton extends StatelessWidget {
  final String heroTag;
  final ButtonType buttonType;
  final Function() onTap;
  final IconData iconData;
  final bool? disabled;
  final bool isMini;
  final bool isShowing;

  const PsFloatingButton(
      {super.key,
      required this.heroTag,
      required this.buttonType,
      required this.onTap,
      required this.iconData,
      this.disabled,
      this.isMini = false,
      this.isShowing = true});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: Shared.getButtonBackgroundColor(buttonType),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      mini: isMini,
      elevation: isShowing ? 6 : 0,
      highlightElevation: 0,
      child: Icon(iconData, color: Shared.getButtonTextColor(buttonType)),
    );
  }
}
