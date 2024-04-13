import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/screens/registration_screen.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_elevated_button.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_text_field.dart';

import '../models/validation.dart';
import '../util/constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled = true;
  //bool _dniIsValid = false;
  //bool _passwordIsValid = false;
  //final String dniValidationMessage = ;
  List<Validation> dniValidations = [
    Validation("8 dígitos numéricos", false)
  ];
  List<Validation> passwordValidations = [
    Validation("Al menos 8 caracteres", false),
    Validation("Al menos 1 letra del alfabeto", false),
    Validation("Al menos 1 número", false),
    Validation("Al menos 1 caracter especial", false),
  ];

  @override
  void initState() {
    super.initState();
    _dniController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
  }

  void _checkFields() {
    final dniLengthValidation = RegExp(r'^\d{8}$').hasMatch(_dniController.text);
    final passwordLengthValidation = _passwordController.text.length >= 8;
    final passwordAlphabetValidation = RegExp(r'[a-zA-Z]').hasMatch(_passwordController.text);
    final passwordNumberValidation = RegExp(r'\d').hasMatch(_passwordController.text);
    final passwordSpecialCharacterValidation = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text);


    setState(() {
      dniValidations[0].isValid = dniLengthValidation;

      passwordValidations[0].isValid = passwordLengthValidation;
      passwordValidations[1].isValid = passwordAlphabetValidation;
      passwordValidations[2].isValid = passwordNumberValidation;
      passwordValidations[3].isValid = passwordSpecialCharacterValidation;


      _isButtonDisabled = !(dniLengthValidation &&
          passwordLengthValidation &&
          passwordAlphabetValidation &&
          passwordSpecialCharacterValidation);
    });
  }

  void _login() async {
    setState(() {
      _isButtonDisabled = true;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Se está procesando su solicitud\nEspere un momento por favor'),
              CircularProgressIndicator(),
            ],
          ),
          duration: Duration(hours: 1),
        ),
      );

    try {
      var apiService = Provider.of<ApiService>(context, listen: false);
      bool loggedIn =
          await apiService.login(_dniController.text, _passwordController.text);
      if (loggedIn) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
        setState(() {
          _isButtonDisabled = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        _isButtonDisabled = false;
      });
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/Logo_b.png'),
              height: 50,
            ),
            const SizedBox(height: 20),
            const Text('Bienvenido',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 20),
            PteriscopeTextField(
                controller: _dniController,
                hintText: 'DNI',
                obscureText: false,
                inputType: TextInputType.number,
                isValid: dniValidations.every((validation) => validation.isValid),
                validations: dniValidations),
            const SizedBox(height: 20),
            PteriscopeTextField(
                controller: _passwordController,
                hintText: 'Contraseña',
                obscureText: true,
                inputType: TextInputType.text,
                isValid: passwordValidations.every((validation) => validation.isValid),
                validations: passwordValidations),
            const SizedBox(height: 20),
            PteriscopeElevatedButton(
                width: MediaQuery.of(context).size.width,
                enabled: _isButtonDisabled,
                onTap: _isButtonDisabled ? null : _login,
                text: 'Ingresar'),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const RegistrationScreen()));
              },
              child: const Text('¿No tiene una cuenta? Registrarse'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _dniController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
