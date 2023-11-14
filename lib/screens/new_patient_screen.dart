import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/models/patient.dart';
import 'package:pteriscope_frontend/models/register_patient.dart';
import 'package:pteriscope_frontend/screens/patient_detail_screen.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_app_bar.dart';

import '../services/api_service.dart';
import '../util/constants.dart';
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
    final nameIsValid = _nameController.text.length >= 3;
    final lastNameIsValid = _lastNameController.text.length >= 3;
    final dniIsValid = RegExp(r'^\d{8}$').hasMatch(_dniController.text);
    final ageIsValid = int.tryParse(_ageController.text) != null &&
        int.parse(_ageController.text) > 18;
    final emailIsValid = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
      multiLine: false,
    ).hasMatch(_emailController.text);

    setState(() {
      _isButtonDisabled = !(nameIsValid &&
          lastNameIsValid &&
          dniIsValid &&
          ageIsValid &&
          emailIsValid);
    });
  }

  void _register() async {
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
              Text('Registrando paciente...'),
              CircularProgressIndicator(),
            ],
          ),
          duration: Duration(hours: 1),
        ),
      );

    try {
      var apiService = Provider.of<ApiService>(context, listen: false);
      Patient? patient = await apiService.createPatient(RegisterPatient(
          firstName: _nameController.text,
          lastName: _lastNameController.text,
          dni: _dniController.text,
          age: int.parse(_ageController.text),
          email: _emailController.text));

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (patient != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: patient),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro fallido')),
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
                    inputType: TextInputType.name),
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _lastNameController,
                    hintText: 'Apellidos',
                    obscureText: false,
                    inputType: TextInputType.name),
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _dniController,
                    hintText: 'DNI',
                    obscureText: false,
                    inputType: TextInputType.number),
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _ageController,
                    hintText: 'Edad',
                    obscureText: false,
                    inputType: TextInputType.number),
                const SizedBox(height: 15),
                PteriscopeTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    inputType: TextInputType.emailAddress),
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
