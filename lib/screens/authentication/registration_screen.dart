import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/models/register_user.dart';
import 'package:pteriscope_frontend/util/ps_exception.dart';
import 'package:pteriscope_frontend/widgets/ps_text_field.dart';

import '../../util/enum/snack_bar_type.dart';
import '../../util/shared.dart';
import '../../util/validation.dart';
import '../../services/api_service.dart';
import '../../util/constants.dart';
import '../../widgets/ps_elevated_button.dart';
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  bool _isButtonDisabled = true;

  List<Validation> nameValidations = [
    Validation("Al menos un nombre y dos apellidos", false),
    Validation("Solo valores alfanuméricos", false),
  ];
  List<Validation> dniValidations = [
    Validation("8 dígitos numéricos", false)
  ];
  List<Validation> passwordValidations = [
    Validation("Al menos 8 caracteres", false),
    Validation("Al menos 1 letra del alfabeto", false),
    Validation("Al menos 1 número", false),
    Validation("Al menos 1 caracter especial", false),
  ];
  List<Validation> hospitalValidations = [
    Validation("Al menos 3 caracteres", false),
  ];
  List<Validation> positionValidations = [
    Validation("Al menos 5 caracteres", false),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFields);
    _dniController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
    _hospitalController.addListener(_checkFields);
    _positionController.addListener(_checkFields);
  }

  void _checkFields() {
    final nameSurnameValidation = _nameController.text
            .split(' ')
            .where((word) => word.isNotEmpty)
            .length >= 3;
    final nameAlphanumericValidation = RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(_nameController.text);

    final dniLengthValidation = RegExp(r'^\d{8}$').hasMatch(_dniController.text);

    final passwordLengthValidation = _passwordController.text.length >= 8;
    final passwordAlphabetValidation = RegExp(r'[a-zA-Z]').hasMatch(_passwordController.text);
    final passwordNumberValidation = RegExp(r'\d').hasMatch(_passwordController.text);
    final passwordSpecialCharacterValidation = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text);

    final hospitalLengthValidation = _hospitalController.text.length >= 3;

    final positionLengthValidation = _positionController.text.length >= 5;

    setState(() {
      nameValidations[0].isValid = nameSurnameValidation;
      nameValidations[1].isValid = nameAlphanumericValidation;

      dniValidations[0].isValid = dniLengthValidation;

      passwordValidations[0].isValid = passwordLengthValidation;
      passwordValidations[1].isValid = passwordAlphabetValidation;
      passwordValidations[2].isValid = passwordNumberValidation;
      passwordValidations[3].isValid = passwordSpecialCharacterValidation;

      hospitalValidations[0].isValid = hospitalLengthValidation;
      positionValidations[0].isValid = positionLengthValidation;

      _isButtonDisabled = !(nameSurnameValidation &&
          nameAlphanumericValidation &&
          dniLengthValidation &&
          passwordLengthValidation &&
          passwordAlphabetValidation &&
          passwordNumberValidation &&
          passwordSpecialCharacterValidation &&
          hospitalLengthValidation &&
          positionLengthValidation);
    });
  }

  void _register() async {
    setState(() {
      _isButtonDisabled = true;
    });

    try {
      bool _ = await Shared.checkConnectivity();

      var apiService = Provider.of<ApiService>(context, listen: false);
      Shared.showPSSnackBar(
          context,
          'Registrando...',
          SnackBarType.loading,
          AppConstants.longSnackBarDuration);
      bool registered = await apiService.registerSpecialist(RegisterUser(
          name: _nameController.text,
          dni: _dniController.text,
          password: _passwordController.text,
          hospital: _hospitalController.text,
          position: _positionController.text));

      if (registered) {
        Shared.showPSSnackBar(
            context,
            'Registro exitoso',
            SnackBarType.onlyText,
            AppConstants.shortSnackBarDuration);
        Navigator.of(context).pop();
      } else {
        Shared.showPSSnackBar(
            context,
            'Registro fallido',
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
          'Registro fallido',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              const Image(
                image: AssetImage('assets/Logo_b.png'),
                height: 50,
              ),
              const SizedBox(height: 20),
              const Text('Registrarse',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 15),
              PsTextField(
                  controller: _nameController,
                  hintText: 'Nombres completos',
                  obscureText: false,
                  inputType: TextInputType.name,
                  isValid: nameValidations.every((validation) => validation.isValid),
                  validations: nameValidations),
              const SizedBox(height: 15),
              PsTextField(
                  controller: _dniController,
                  hintText: 'DNI',
                  obscureText: false,
                  inputType: TextInputType.number,
                  isValid: dniValidations.every((validation) => validation.isValid),
                  validations: dniValidations),
              const SizedBox(height: 15),
              PsTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  inputType: TextInputType.text,
                  isValid: passwordValidations.every((validation) => validation.isValid),
                  validations: passwordValidations),
              const SizedBox(height: 15),
              PsTextField(
                  controller: _hospitalController,
                  hintText: 'Hospital',
                  obscureText: false,
                  inputType: TextInputType.text,
                  isValid: hospitalValidations.every((validation) => validation.isValid),
                  validations: hospitalValidations),
              const SizedBox(height: 15),
              PsTextField(
                  controller: _positionController,
                  hintText: 'Cargo',
                  obscureText: false,
                  inputType: TextInputType.text,
                  isValid: positionValidations.every((validation) => validation.isValid),
                  validations: positionValidations),
              const SizedBox(height: 95),
              PsElevatedButton(
                  width: MediaQuery.of(context).size.width,
                  enabled: _isButtonDisabled,
                  onTap: _isButtonDisabled ? null : _register,
                  text: 'Crear cuenta'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('¿Ya tiene una cuenta? Ingresar'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dniController.dispose();
    _passwordController.dispose();
    _hospitalController.dispose();
    _positionController.dispose();
    super.dispose();
  }
}
