import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../util/validation.dart';
import '../util/constants.dart';

class PsTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  final bool isValid;
  final List<Validation> validations;

  const PsTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    required this.isValid,
    required this.validations,
  });

  @override
  State<PsTextField> createState() => _PsTextFieldState();
}

class _PsTextFieldState extends State<PsTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.hintText,
        enabledBorder: (widget.controller.text.isEmpty || widget.isValid)
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))
            : const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.primaryColor)),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0)),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.obscureText && widget.controller.text.isNotEmpty)
              IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: _toggleObscureText,
              ),
            if (!(widget.controller.text.isEmpty || widget.isValid))
              JustTheTooltip(
                preferredDirection: AxisDirection.values.first,
                triggerMode: TooltipTriggerMode.tap,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: widget.validations
                        .map((validation) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  validation.isValid
                                      ? Icons.check
                                      : Icons.close,
                                  color: validation.isValid
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  validation.message,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
                backgroundColor: Colors.black,
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
      obscureText: _obscureText,
      keyboardType: widget.inputType,
    );
  }
}
