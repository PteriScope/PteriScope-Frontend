import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/models/patient.dart';
import 'package:pteriscope_frontend/models/register_patient.dart';
import 'package:pteriscope_frontend/screens/patient/patient_detail_screen.dart';
import 'package:pteriscope_frontend/widgets/ps_app_bar.dart';

import '../../util/enum/dialog_type.dart';
import '../../util/enum/snack_bar_type.dart';
import '../../util/shared.dart';
import '../../util/validation.dart';
import '../../services/api_service.dart';
import '../../util/constants.dart';
import '../../util/ps_exception.dart';
import '../../util/enum/current_screen.dart';
import '../../widgets/ps_elevated_button.dart';
import '../../widgets/ps_menu_bar.dart';
import '../../widgets/ps_text_field.dart';

class EditPatientScreen extends StatefulWidget {
  final Patient patient;

  const EditPatientScreen({super.key, required this.patient});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
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
  List<Validation> dniValidations = [Validation("8 dígitos numéricos", false)];
  List<Validation> ageValidations = [
    Validation("Solo valores numéricos", false),
    Validation("No empezar con cero", false),
  ];
  List<Validation> emailValidations = [Validation("Email válido", false)];
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFields);
    _lastNameController.addListener(_checkFields);
    _dniController.addListener(_checkFields);
    _ageController.addListener(_checkFields);
    _emailController.addListener(_checkFields);
    initializeFieldsText();
  }

  void initializeFieldsText() {
    _nameController.text = widget.patient.firstName;
    _lastNameController.text = widget.patient.lastName;
    _dniController.text = widget.patient.dni;
    _ageController.text = widget.patient.age.toString();
    _emailController.text = widget.patient.email;
  }

  void _checkFields() {
    final nameAlphanumericValidation =
        RegExp(r'^[a-zA-Z0-9\sáéíóúÁÉÍÓÚüÜ]+$').hasMatch(_nameController.text);

    final twoLastnameValidation = _lastNameController.text
            .split(' ')
            .where((word) => word.isNotEmpty)
            .length >=
        2;
    final lastnameAlphanumericValidation =
        RegExp(r'^[a-zA-Z0-9\sáéíóúÁÉÍÓÚüÜ]+$').hasMatch(_lastNameController.text);

    final dniLengthValidation =
        RegExp(r'^\d{8}$').hasMatch(_dniController.text);

    final ageNumericValidation =
        RegExp(r'^[0-9]+$').hasMatch(_ageController.text);
    final ageNotZeroStartingValidation =
        RegExp(r'^[1-9][0-9]*$').hasMatch(_ageController.text);

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

      _isButtonDisabled = !(nameAlphanumericValidation &&
          twoLastnameValidation &&
          lastnameAlphanumericValidation &&
          dniLengthValidation &&
          ageNumericValidation &&
          ageNotZeroStartingValidation &&
          (emailValidation || _emailController.text == ""));
    });
  }

  void showConfirmDialog() {
    Shared.showPsDialog(
        context,
        DialogType.confirmation,
        "¿Estás seguro que deseas actualizar los datos del paciente?",
        "Aceptar",
        () => {_updatePatient(), Navigator.of(context).pop()},
        Icons.check_circle,
        "Cancelar",
        () => {Navigator.of(context).pop()},
        Icons.cancel);
  }

  void _updatePatient() async {
    setState(() {
      _isButtonDisabled = true;
      _isUpdating = true;
    });

    try {
      bool _ = await Shared.checkConnectivity();

      var apiService = Provider.of<ApiService>(context, listen: false);
      //TODO: CHECK WITH EXCEL
      Shared.showPSSnackBar(context, 'Actualizando datos...',
          SnackBarType.loading, AppConstants.longSnackBarDuration);
      Patient? patient = await apiService.updatePatient(
          widget.patient.id,
          RegisterPatient(
              firstName: _nameController.text,
              lastName: _lastNameController.text,
              dni: _dniController.text,
              age: int.parse(_ageController.text),
              email: _emailController.text));

      Shared.showPSSnackBar(context, 'Edición exitosa', SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PatientDetailScreen(patient: patient),
        ),
      );
    } on PsException catch (e) {
      Shared.showPSSnackBar(context, 'Error: ${e.message}',
          SnackBarType.onlyText, AppConstants.shortSnackBarDuration);
    } on SocketException catch (_) {
      Shared.showPSSnackBar(
          context,
          'Hubo un error al tratar de conectarse al servidor. Inténtelo más tarde, por favor',
          SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
    } catch (e) {
      Shared.showPSSnackBar(context, 'Registro fallido', SnackBarType.onlyText,
          AppConstants.shortSnackBarDuration);
    }
    setState(() {
      _isButtonDisabled = false;
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: widget.patient),
          ),
        );
      },
      child: Scaffold(
        appBar: PsAppBar(
            title: 'Editar paciente',
            titleSize: AppConstants.bigAppBarTitleSize,
            disabled: _isUpdating),
        drawer: const PsMenuBar(currentView: CurrentScreen.other),
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
                  PsTextField(
                      controller: _nameController,
                      hintText: 'Nombre',
                      obscureText: false,
                      inputType: TextInputType.name,
                      isValid: nameValidations
                          .every((validation) => validation.isValid),
                      validations: nameValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _lastNameController,
                      hintText: 'Apellidos',
                      obscureText: false,
                      inputType: TextInputType.name,
                      isValid: lastnameValidations
                          .every((validation) => validation.isValid),
                      validations: lastnameValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _dniController,
                      hintText: 'DNI',
                      obscureText: false,
                      inputType: TextInputType.number,
                      isValid: dniValidations
                          .every((validation) => validation.isValid),
                      validations: dniValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _ageController,
                      hintText: 'Edad',
                      obscureText: false,
                      inputType: TextInputType.number,
                      isValid: ageValidations
                          .every((validation) => validation.isValid),
                      validations: ageValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _emailController,
                      hintText: 'Email (opcional)',
                      obscureText: false,
                      inputType: TextInputType.emailAddress,
                      isValid: emailValidations
                          .every((validation) => validation.isValid),
                      validations: emailValidations),
                  const SizedBox(height: 75),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PsElevatedButton(
                          width: MediaQuery.of(context).size.width / 2.5,
                          disabled: _isUpdating,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          text: 'Cancelar'),
                      PsElevatedButton(
                          width: MediaQuery.of(context).size.width / 2.5,
                          disabled: _isButtonDisabled,
                          onTap: showConfirmDialog,
                          text: 'Actualizar'),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
