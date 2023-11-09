import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/constants.dart';

class PteriscopeTextField extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;

  const PteriscopeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: hintText,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppConstants.primaryColor)
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          )
      ),
      obscureText: obscureText,
      keyboardType: inputType,
    );
  }
}