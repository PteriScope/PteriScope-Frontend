import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/screens/authentication/registration_screen.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/widgets/ps_elevated_button.dart';
import 'package:pteriscope_frontend/widgets/ps_text_field.dart';

import '../../util/enum/snack_bar_type.dart';
import '../../util/shared.dart';
import '../../util/validation.dart';
import '../../util/constants.dart';
import '../../util/ps_exception.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled = true;
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

    try {
      bool _ = await Shared.checkConnectivity();

      var apiService = Provider.of<ApiService>(context, listen: false);

      Shared.showPSSnackBar(
          context,
          'Se está procesando su solicitud\nEspere un momento por favor',
          SnackBarType.loading,
          AppConstants.longSnackBarDuration);

      bool loggedIn =
          await apiService.login(_dniController.text, _passwordController.text);
      if (loggedIn) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Shared.showPSSnackBar(
            context,
            'Credenciales incorrectas',
            SnackBarType.onlyText,
            AppConstants.shortSnackBarDuration);
      }
    } on PsException catch(e){
      Shared.showPSSnackBar(
          context,
          'Error: ${e.message}',
          SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
    } on SocketException catch(_) {
      Shared.showPSSnackBar(
          context,
          'Hubo un error al tratar de conectarse al servidor. Inténtelo más tarde, por favor',
          SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
    } catch (e) {
      Shared.showPSSnackBar(
          context,
          'Inicio de sesión fallido',
          SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
    }
    setState(() {
      _isButtonDisabled = false;
    });
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
            PsTextField(
                controller: _dniController,
                hintText: 'DNI',
                obscureText: false,
                inputType: TextInputType.number,
                isValid: dniValidations.every((validation) => validation.isValid),
                validations: dniValidations),
            const SizedBox(height: 20),
            PsTextField(
                controller: _passwordController,
                hintText: 'Contraseña',
                obscureText: true,
                inputType: TextInputType.text,
                isValid: passwordValidations.every((validation) => validation.isValid),
                validations: passwordValidations),
            const SizedBox(height: 20),
            PsElevatedButton(
                width: MediaQuery.of(context).size.width,
                disabled: _isButtonDisabled,
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
