import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/util/constants.dart';
import 'package:pteriscope_frontend/util/enum/dialog_type.dart';
import 'package:pteriscope_frontend/widgets/ps_elevated_button_icon.dart';

class PsDialog extends StatelessWidget {
  final DialogType dialogType;
  final String content;
  final String mainButtonText;
  final Function() mainButtonAction;
  final IconData mainButtonIcon;
  final String? secondaryButtonText;
  final Function()? secondaryButtonAction;
  final IconData? secondaryButtonIcon;

  const PsDialog({
    super.key,
    required this.dialogType,
    required this.content,
    required this.mainButtonText,
    required this.mainButtonAction,
    required this.mainButtonIcon,
    required this.secondaryButtonText,
    required this.secondaryButtonAction,
    required this.secondaryButtonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      content: Text(
        content,
        style: const TextStyle(fontSize: 17.5),
        textAlign: TextAlign.center,
      ),
      icon: dialogType == DialogType.confirmation
          ? const Icon(Icons.edit, size: 50)
          : dialogType == DialogType.warning
              ? const Icon(Icons.warning, size: 50)
              : const Icon(Icons.error, size: 50),
      backgroundColor: dialogType == DialogType.confirmation
          ? null
          : dialogType == DialogType.warning
              ? const Color(0xFFFFFFFF)
              : const Color(0xFFFFE9E9),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: const EdgeInsets.all(AppConstants.padding),
      actions: [
        if (secondaryButtonText != null &&
            secondaryButtonAction != null &&
            secondaryButtonIcon != null)
          PsElevatedButtonIcon(
            isPrimary: true,
            icon: secondaryButtonIcon!,
            text: secondaryButtonText!,
            onTap: secondaryButtonAction!,
          ),
        PsElevatedButtonIcon(
          isPrimary: true,
          icon: mainButtonIcon,
          text: mainButtonText,
          onTap: mainButtonAction,
        ),
      ],
    );
  }
}
