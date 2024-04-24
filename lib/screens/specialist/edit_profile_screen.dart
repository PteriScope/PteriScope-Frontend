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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  bool _isButtonDisabled = true;
  bool _isUpdating = false;

  List<Validation> nameValidations = [
    Validation("Al menos un nombre y dos apellidos", false),
    Validation("Solo valores alfanuméricos", false),
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

  late final int specialistId;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
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
        RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(_nameController.text);

    final passwordLengthValidation = _passwordController.text.length >= 8;
    final passwordAlphabetValidation =
        RegExp(r'[a-zA-Z]').hasMatch(_passwordController.text);
    final passwordNumberValidation =
        RegExp(r'\d').hasMatch(_passwordController.text);
    final passwordSpecialCharacterValidation =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text);

    final hospitalLengthValidation = _hospitalController.text.length >= 3;

    final positionLengthValidation = _positionController.text.length >= 5;

    setState(() {
      nameValidations[0].isValid = nameSurnameValidation;
      nameValidations[1].isValid = nameAlphanumericValidation;

      passwordValidations[0].isValid = passwordLengthValidation;
      passwordValidations[1].isValid = passwordAlphabetValidation;
      passwordValidations[2].isValid = passwordNumberValidation;
      passwordValidations[3].isValid = passwordSpecialCharacterValidation;

      hospitalValidations[0].isValid = hospitalLengthValidation;
      positionValidations[0].isValid = positionLengthValidation;

      _isButtonDisabled = !(nameSurnameValidation &&
          nameAlphanumericValidation &&
          passwordLengthValidation &&
          passwordAlphabetValidation &&
          passwordNumberValidation &&
          passwordSpecialCharacterValidation &&
          hospitalLengthValidation &&
          positionLengthValidation);
    });
  }

  void showConfirmDialog() {
    Shared.showPsDialog(
        context,
        DialogType.confirmation,
        "¿Estás seguro que deseas actualizar tus datos?",
        "Actualizar",
        () => {_updateProfile(), Navigator.of(context).pop()},
        Icons.check_circle,
        "Cancelar",
        () => {Navigator.of(context).pop()},
        Icons.cancel);
  }

  void _updateProfile() async {
    setState(() {
      _isButtonDisabled = true;
      _isUpdating = true;
    });

    try {
      bool __ = await Shared.checkConnectivity();

      var apiService = Provider.of<ApiService>(context, listen: false);
      Shared.showPSSnackBar(
          context,
          //TODO: CHECK WITH EXCEL
          'Actualizando datos...',
          SnackBarType.loading,
          AppConstants.longSnackBarDuration);
      Specialist? _ = await apiService.updateSpecialist(
          specialistId,
          RegisterUser(
              name: _nameController.text,
              dni: widget.specialist.dni,
              password: _passwordController.text,
              hospital: _hospitalController.text,
              position: _positionController.text));

      Shared.showPSSnackBar(context, 'Actualización exitosa',
          SnackBarType.onlyText, AppConstants.shortSnackBarDuration);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
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
                      hintText: 'Nombre',
                      obscureText: false,
                      inputType: TextInputType.name,
                      isValid: nameValidations
                          .every((validation) => validation.isValid),
                      validations: nameValidations),
                  const SizedBox(height: 15),
                  PsTextField(
                      controller: _passwordController,
                      hintText: 'Contraseña',
                      obscureText: true,
                      inputType: TextInputType.text,
                      isValid: passwordValidations
                          .every((validation) => validation.isValid),
                      validations: passwordValidations),
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
                          text: 'Actualizar datos'),
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
