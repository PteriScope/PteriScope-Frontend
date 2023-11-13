import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/models/register_user.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_text_field.dart';

import '../services/api_service.dart';
import '../util/constants.dart';
import '../widgets/pteriscope_elevated_button.dart';

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
    final nameIsValid = _nameController.text
            .split(' ')
            .where((word) => word.isNotEmpty)
            .length >=
        3;
    final dniIsValid = RegExp(r'^\d{8}$').hasMatch(_dniController.text);
    final passwordIsValid = _passwordController.text.length >= 5;
    final hospitalIsValid = _hospitalController.text.length >= 3;
    final positionIsValid = _positionController.text.length >= 5;

    setState(() {
      _isButtonDisabled = !(nameIsValid &&
          dniIsValid &&
          passwordIsValid &&
          hospitalIsValid &&
          positionIsValid);
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
              Text('Registrando...'),
              CircularProgressIndicator(),
            ],
          ),
          duration: Duration(hours: 1),
        ),
      );

    try {
      var apiService = Provider.of<ApiService>(context, listen: false);
      bool registered = await apiService.registerSpecialist(RegisterUser(
          name: _nameController.text,
          dni: _dniController.text,
          password: _passwordController.text,
          hospital: _hospitalController.text,
          position: _positionController.text));

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (registered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
        Navigator.of(context).pop();
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
              PteriscopeTextField(
                  controller: _nameController,
                  hintText: 'Nombre',
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
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  inputType: TextInputType.text),
              const SizedBox(height: 15),
              PteriscopeTextField(
                  controller: _hospitalController,
                  hintText: 'Hospital',
                  obscureText: false,
                  inputType: TextInputType.text),
              const SizedBox(height: 15),
              PteriscopeTextField(
                  controller: _positionController,
                  hintText: 'Cargo',
                  obscureText: false,
                  inputType: TextInputType.text),
              const SizedBox(height: 95),
              PteriscopeElevatedButton(
                  width: MediaQuery.of(context).size.width,
                  enabled: _isButtonDisabled,
                  onTap: _isButtonDisabled ? null : _register,
                  text: 'Crear cuenta'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Return to the previous screen
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
