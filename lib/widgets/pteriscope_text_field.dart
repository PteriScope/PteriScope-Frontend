import 'package:flutter/material.dart';

import '../util/constants.dart';

class PteriscopeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  final bool isValid;

  const PteriscopeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    required this.isValid,
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
            ? const Tooltip(
          message: 'Mensaje de error aquí', // Personaliza el mensaje de error según el campo
          child: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        )
            : null, // No muestra el ícono si el campo es válido
      ),
      obscureText: obscureText,
      keyboardType: inputType,
    );
  }
}
