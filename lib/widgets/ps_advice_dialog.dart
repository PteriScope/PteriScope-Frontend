import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';
import 'package:pteriscope_frontend/widgets/ps_elevated_button_icon.dart';
import 'package:pteriscope_frontend/widgets/ps_floating_button.dart';

import '../services/api_service.dart';
import '../util/advice.dart';
import '../util/constants.dart';
import '../util/enum/button_type.dart';

class PsAdviceDialog extends StatefulWidget {
  final List<Advice> advices;
  final bool isResultAdvice;
  const PsAdviceDialog(
      {Key? key, required this.advices, this.isResultAdvice = false})
      : super(key: key);

  @override
  State<PsAdviceDialog> createState() => _PsAdviceDialogState();
}

class _PsAdviceDialogState extends State<PsAdviceDialog> {
  late int currentIndex = 0;

  bool isCheckboxChecked = false;
  ApiService apiService = ApiService();
  final specialistId = SharedPreferencesService().getId();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isResultAdvice
            ? "Consejos para el paciente"
            : "Consejos para crear una revisión",
        style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.only(
          top: AppConstants.padding,
          left: AppConstants.padding,
          right: AppConstants.padding,
          bottom: 0),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PsFloatingButton(
              heroTag: 'previousAdvice',
              buttonType: ButtonType.secondary,
              onTap: () {
                if (currentIndex > 0) {
                  setState(() {
                    currentIndex -= 1;
                  });
                }
              },
              iconData: Icons.chevron_left,
              isMini: true),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.advices[currentIndex].imagePath != null)
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppConstants.padding / 2.0),
                  child: Image(
                    image: AssetImage(widget.advices[currentIndex].imagePath!),
                    height: 100,
                  ),
                ),
              if (widget.advices[currentIndex].imagePath != null)
                const SizedBox(height: AppConstants.padding),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding / 4),
                width: MediaQuery.of(context).size.width * 0.45,
                child: Text(
                  widget.advices[currentIndex].adviceMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: AppConstants.padding),
              Text(
                '${currentIndex + 1}/${widget.advices.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          PsFloatingButton(
            heroTag: 'nextAdvice',
            buttonType: ButtonType.secondary,
            onTap: () {
              if (currentIndex < widget.advices.length - 1) {
                setState(() {
                  currentIndex += 1;
                });
              }
            },
            iconData: Icons.chevron_right,
            isMini: true,
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.only(
          top: 0,
          left: AppConstants.padding / 3.0,
          right: AppConstants.padding,
          bottom: AppConstants.padding),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        if (!widget.isResultAdvice)
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: isCheckboxChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckboxChecked = value!;
                    });
                  },
                ),
                const Text(
                  'No volver a mostrar',
                  style: TextStyle(fontSize: 11),
                ),
              ]),
        PsElevatedButtonIcon(
          isPrimary: true,
          icon: Icons.check,
          text: "Ententido",
          onTap: () async {
            if (isCheckboxChecked && !widget.isResultAdvice) {
              await apiService.markDoNotShowAdvice(specialistId!);
            }
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
