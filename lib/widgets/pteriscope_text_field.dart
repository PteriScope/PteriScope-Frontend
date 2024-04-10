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
        enabledBorder: isValid // Cambia el borde según la validez del campo
            ? const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))
            : const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)), // Si no es válido, muestra el borde rojo
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppConstants.primaryColor)),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
        suffixIcon: !isValid // Añade un ícono de alerta si no es válido
            ? IconButton(
              icon: const Icon(Icons.error_outline),
                onPressed: () {
                  // Mostrar mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mensaje de error aquí'), // Personaliza el mensaje de error según el campo
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
              )
            : null, // No muestra el ícono si el campo es válido
      ),
      obscureText: obscureText,
      keyboardType: inputType,
    );
  }
}
