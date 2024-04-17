import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/models/patient.dart';
import 'package:pteriscope_frontend/models/register_patient.dart';
import 'package:pteriscope_frontend/screens/patient_detail_screen.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_app_bar.dart';

import '../models/validation.dart';
import '../services/api_service.dart';
import '../util/constants.dart';
import '../util/pteriscope_exception.dart';
import '../util/pteriscope_function.dart';
import '../widgets/pteriscope_elevated_button.dart';
import '../widgets/pteriscope_text_field.dart';
import 'home_screen.dart';

class NewPatient extends StatefulWidget {
  const NewPatient({super.key});

  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonDisabled = true;

  List<Validation> nameValidations = [
    Validation("Solo valores alfanuméricos", false),
  ];
  List<Validation> lastnameValidations = [
    Validation("2 apellidos", false),
    Validation("Solo valores alfanuméricos", false),
  ];
  List<Validation> dniValidations = [
    Validation("8 dígitos numéricos", false)
  ];
  List<Validation> ageValidations = [
    Validation("Solo valores numéricos", false),
    Validation("No empezar con cero", false),
  ];
  List<Validation> emailValidations = [
    Validation("Email válido", false)
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFields);
    _lastNameController.addListener(_checkFields);
    _dniController.addListener(_checkFields);
    _ageController.addListener(_checkFields);
    _emailController.addListener(_checkFields);
  }

  void _checkFields() {
    final nameAlphanumericValidation = RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(_nameController.text);

    final twoLastnameValidation = _lastNameController.text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .length >= 2;
    final lastnameAlphanumericValidation = RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(_lastNameController.text);

    final dniLengthValidation = RegExp(r'^\d{8}$').hasMatch(_dniController.text);

    final ageNumericValidation = RegExp(r'^[0-9]+$').hasMatch(_ageController.text);
    final ageNotZeroStartingValidation = RegExp(r'^[1-9][0-9]*$').hasMatch(_ageController.text);

    final emailValidation = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
      multiLine: false,
    ).hasMatch(_emailController.text);

    setState(() {
      nameValidations[0].isValid = nameAlphanumericValidation;

      lastnameValidations[0].isValid = twoLastnameValidation;
      lastnameValidations[1].isValid = lastnameAlphanumericValidation;

      dniValidations[0].isValid = dniLengthValidation;

      ageValidations[0].isValid = ageNumericValidation;
      ageValidations[1].isValid = ageNotZeroStartingValidation;

      emailValidations[0].isValid = emailValidation;

      _isButtonDisabled = !(
          nameAlphanumericValidation &&
          twoLastnameValidation &&
          lastnameAlphanumericValidation &&
          dniLengthValidation &&
          ageNumericValidation &&
          ageNotZeroStartingValidation &&
          emailValidation);
    });
  }

  void _register() async {
    setState(() {
      _isButtonDisabled = true;
    });

    try {
      bool _ = await PteriscopeFunction.checkConnectivity();

      var apiService = Provider.of<ApiService>(context, listen: false);
      PteriscopeFunction.PtriscopeSnackBar(
          context,
          'Registrando paciente...',
          SnackBarType.loading,
          AppConstants.longSnackBarDuration);
      Patient? patient = await apiService.createPatient(RegisterPatient(
          firstName: _nameController.text,
          lastName: _lastNameController.text,
          dni: _dniController.text,
          age: int.parse(_ageController.text),
          email: _emailController.text));

      if (patient != null) {
        PteriscopeFunction.PtriscopeSnackBar(
            context,
            'Registro exitoso',
            SnackBarType.onlyText,
            AppConstants.shortSnackBarDuration);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: patient),
          ),
        );
      } else {
        PteriscopeFunction.PtriscopeSnackBar(
            context,
            'Registro fallido',
            SnackBarType.onlyText,
            AppConstants.shortSnackBarDuration);
      }
    } on PteriscopeException catch(e){
      PteriscopeFunction.PtriscopeSnackBar(
          context,
          'Error: ${e.message}',
          SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
    } on SocketException catch(_) {
      PteriscopeFunction.PtriscopeSnackBar(
          context,
          'Hubo un error al tratar de conectarse al servidor. Inténtelo más tarde, por favor',
          SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
    } catch (e) {
      PteriscopeFunction.PtriscopeSnackBar(
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
      appBar: const PteriscopeAppBar(title: 'Nuevo paciente'),
      body: SingleChildScrollView(
        child: Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(
            top: AppConstants.padding,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _nameController,
                    hintText: 'Nombre',
                    obscureText: false,
                    inputType: TextInputType.name,
                    isValid: nameValidations.every((validation) => validation.isValid),
                    validations: nameValidations),
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _lastNameController,
                    hintText: 'Apellidos',
                    obscureText: false,
                    inputType: TextInputType.name,
                    isValid: lastnameValidations.every((validation) => validation.isValid),
                    validations: lastnameValidations),
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _dniController,
                    hintText: 'DNI',
                    obscureText: false,
                    inputType: TextInputType.number,
                    isValid: dniValidations.every((validation) => validation.isValid),
                    validations: dniValidations),
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _ageController,
                    hintText: 'Edad',
                    obscureText: false,
                    inputType: TextInputType.number,
                    isValid: ageValidations.every((validation) => validation.isValid),
                    validations: ageValidations),
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    inputType: TextInputType.emailAddress,
                    isValid: emailValidations.every((validation) => validation.isValid),
                    validations: emailValidations),
                const SizedBox(height: 75),
                PteriscopeElevatedButton(
                    width: MediaQuery.of(context).size.width,
                    enabled: _isButtonDisabled,
                    onTap: _isButtonDisabled ? null : _register,
                    text: 'Crear paciente'),
                const SizedBox(height: 75),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'sendEmail',
                      backgroundColor: AppConstants.primaryColor,
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        )
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
