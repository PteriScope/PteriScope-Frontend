import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../models/validation.dart';
import '../util/constants.dart';

class PteriscopeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  final bool isValid;
  final List<Validation> validations;

  const PteriscopeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    required this.isValid,
    required this.validations
  });

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        enabledBorder: (controller.text.isEmpty || isValid)
            ? const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))
            : const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppConstants.primaryColor)),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
        suffixIcon: !(controller.text.isEmpty || isValid)
            ? JustTheTooltip(
                preferredDirection: AxisDirection.values.first,
                triggerMode: TooltipTriggerMode.tap,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: validations.map(
                            (validation) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  validation.isValid ? Icons.check : Icons.close,
                                  color: validation.isValid ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  validation.message,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                    ).toList(),
                  ),
                ),
                backgroundColor: Colors.black,
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              )
            : null,
      ),
      obscureText: obscureText,
      keyboardType: inputType,
    );
  }
}
