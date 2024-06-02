import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/screens/specialist/profile_screen.dart';
import 'package:pteriscope_frontend/util/enum/dialog_type.dart';
import 'package:pteriscope_frontend/widgets/ps_app_bar.dart';

import '../../models/register_user.dart';
import '../../models/specialist.dart';
import '../../services/shared_preferences_service.dart';
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

class EditProfileScreen extends StatefulWidget {
  final Specialist specialist;

  const EditProfileScreen({super.key, required this.specialist});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  bool _isButtonDisabled = true;
  bool _isUpdating = false;

  List<Validation> nameValidations = [
    Validation("Al menos un nombre y dos apellidos", false),
    Validation("Solo valores alfabéticos", false),
  ];
  List<Validation> confirmPasswordValidations = [
    Validation("Al menos 8 caracteres", false),
  ];
  List<Validation> newPasswordValidations = [
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

  late final int specialistId;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFields);
    _confirmPasswordController.addListener(_checkFields);
    _newPasswordController.addListener(_checkFields);
    _hospitalController.addListener(_checkFields);
    _positionController.addListener(_checkFields);
    specialistId = SharedPreferencesService().getId()!;
    initializeFieldsText();
  }

  void initializeFieldsText() {
    _nameController.text = widget.specialist.name;
    _hospitalController.text = widget.specialist.hospital;
    _positionController.text = widget.specialist.position;
  }

  void _checkFields() {
    final nameSurnameValidation = _nameController.text
            .split(' ')
            .where((word) => word.isNotEmpty)
            .length >=
        3;
    final nameAlphanumericValidation =
        RegExp(r'^[a-zA-Z\sáéíóúÁÉÍÓÚüÜ]+$').hasMatch(_nameController.text);

    final confirmPasswordLengthValidation =
        _confirmPasswordController.text.length >= 8;

    final newPasswordLengthValidation = _newPasswordController.text.length >= 8;
    final newPasswordAlphabetValidation =
        RegExp(r'[a-zA-Z]').hasMatch(_newPasswordController.text);
    final newPasswordNumberValidation =
        RegExp(r'\d').hasMatch(_newPasswordController.text);
    final newPasswordSpecialCharacterValidation =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_newPasswordController.text);

    final hospitalLengthValidation = _hospitalController.text.length >= 3;

    final positionLengthValidation = _positionController.text.length >= 5;

    setState(() {
      nameValidations[0].isValid = nameSurnameValidation;
      nameValidations[1].isValid = nameAlphanumericValidation;

      confirmPasswordValidations[0].isValid = confirmPasswordLengthValidation;

      newPasswordValidations[0].isValid = newPasswordLengthValidation;
      newPasswordValidations[1].isValid = newPasswordAlphabetValidation;
      newPasswordValidations[2].isValid = newPasswordNumberValidation;
      newPasswordValidations[3].isValid = newPasswordSpecialCharacterValidation;

      hospitalValidations[0].isValid = hospitalLengthValidation;
      positionValidations[0].isValid = positionLengthValidation;

      _isButtonDisabled = !(nameSurnameValidation &&
          nameAlphanumericValidation &&
          confirmPasswordLengthValidation &&
          ((newPasswordLengthValidation &&
                  newPasswordAlphabetValidation &&
                  newPasswordNumberValidation &&
                  newPasswordSpecialCharacterValidation) ||
              _newPasswordController.text == "") &&
          hospitalLengthValidation &&
          positionLengthValidation);
    });
  }

  void showConfirmDialog() {
    Shared.showPsDialog(
        context,
        DialogType.confirmation,
        "¿Estás seguro que deseas actualizar tus datos?",
        "Aceptar",
        () => {_updateProfile(), Navigator.of(context).pop()},
        Icons.check_circle,
        "Cancelar",
        () => {Navigator.of(context).pop()},
        Icons.cancel);
  }

  void showInvalidPasswordDialog() {
    Shared.showPsDialog(
        context,
        DialogType.warning,
        "La contraseña indicada no coincide con la actual",
        "Aceptar",
        () => {Navigator.of(context).pop()},
        Icons.check_circle);
  }

  void _updateProfile() async {
    setState(() {
      _isButtonDisabled = true;
      _isUpdating = true;
    });

    try {
      bool __ = await Shared.checkConnectivity();

      var apiService = Provider.of<ApiService>(context, listen: false);
      Shared.showPSSnackBar(context, 'Validando...', SnackBarType.loading,
          AppConstants.longSnackBarDuration);
      bool isCurrentPasswordValidated =
          await apiService.validateCurrentPassword(
              specialistId, _confirmPasswordController.text);

      if (!isCurrentPasswordValidated) {
        showInvalidPasswordDialog();
        Shared.showPSSnackBar(context, 'Registro fallido',
            SnackBarType.onlyText, AppConstants.shortSnackBarDuration);
      } else {
        Shared.showPSSnackBar(context, 'Actualizando datos...',
            SnackBarType.loading, AppConstants.shortSnackBarDuration);

        Specialist? _ = await apiService.updateSpecialist(
            specialistId,
            RegisterUser(
                name: _nameController.text,
                dni: widget.specialist.dni,
                password: (_newPasswordController.text == "")
                    ? _confirmPasswordController.text
                    : _newPasswordController.text,
                hospital: _hospitalController.text,
                position: _positionController.text));

        Shared.showPSSnackBar(context, 'Edición exitosa', SnackBarType.onlyText,
            AppConstants.shortSnackBarDuration);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      }
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
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: Scaffold(
        appBar: PsAppBar(
          title: 'Actualizar perfil',
          titleSize: AppConstants.bigAppBarTitleSize,
          disabled: _isUpdating,
        ),
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
                      hintText: 'Nombres completos',
                      obscureText: false,
                      inputType: TextInputType.name,
                      isValid: nameValidations
                          .every((validation) => validation.isValid),
                      validations: nameValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirmar contraseña actual',
                      obscureText: true,
                      inputType: TextInputType.text,
                      isValid: confirmPasswordValidations
                          .every((validation) => validation.isValid),
                      validations: confirmPasswordValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _newPasswordController,
                      hintText: 'Contraseña nueva (opcional)',
                      obscureText: true,
                      inputType: TextInputType.text,
                      isValid: newPasswordValidations
                          .every((validation) => validation.isValid),
                      validations: newPasswordValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _hospitalController,
                      hintText: 'Hospital',
                      obscureText: false,
                      inputType: TextInputType.text,
                      isValid: hospitalValidations
                          .every((validation) => validation.isValid),
                      validations: hospitalValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _positionController,
                      hintText: 'Cargo',
                      obscureText: false,
                      inputType: TextInputType.text,
                      isValid: positionValidations
                          .every((validation) => validation.isValid),
                      validations: positionValidations),
                  const SizedBox(height: 75),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PsElevatedButton(
                          width: MediaQuery.of(context).size.width / 2.5,
                          disabled: _isUpdating,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          text: 'Cancelar'),
                      PsElevatedButton(
                          width: MediaQuery.of(context).size.width / 2.5,
                          disabled: _isButtonDisabled,
                          onTap: showConfirmDialog,
                          text: 'Actualizar'),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
