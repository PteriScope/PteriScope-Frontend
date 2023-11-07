import 'package:flutter/material.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_text_field.dart';

import '../constants.dart';
import '../widgets/pteriscope_elevated_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  //final AuthenticationService _authService = AuthenticationService();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    // Add listeners to each controller
    // TODO: Add
    _nameController.addListener(_checkFields);
    _dniController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
    _hospitalController.addListener(_checkFields);
    _positionController.addListener(_checkFields);
  }

  void _checkFields() {
    if (_nameController.text.isNotEmpty &&
        _dniController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _hospitalController.text.isNotEmpty &&
        _positionController.text.isNotEmpty) {
      if (!_isButtonDisabled) return;
      setState(() => _isButtonDisabled = false);
    } else {
      if (_isButtonDisabled) return;
      setState(() => _isButtonDisabled = true);
    }
  }

  void _register() async {
    // Implement the registration logic here
    // On successful registration, you might want to navigate to the HomeScreen or LoginScreen
    //bool registered = await _authService.register(
    //  _nameController.text,
    //  _dniController.text,
    //  _passwordController.text,
    //  _hospitalController.text,
    //  _positionController.text,
    //);
    bool registered = true;
    if (registered) {
      // Navigate to LoginScreen or HomeScreen
    } else {
      // Show error message
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
              const Text(
                  'Registrarse',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  )
              ),
              const SizedBox(height: 15),
              PteriscopeTextField(
                  controller: _nameController,
                  hintText: 'Nombre',
                  obscureText: false,
                  inputType: TextInputType.name
              ),
              const SizedBox(height: 15),
              PteriscopeTextField(
                  controller: _dniController,
                  hintText: 'DNI',
                  obscureText: false,
                  inputType: TextInputType.number
              ),
              const SizedBox(height: 15),
              PteriscopeTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  inputType: TextInputType.text
              ),
              const SizedBox(height: 15),
              PteriscopeTextField(
                  controller: _hospitalController,
                  hintText: 'Hospital',
                  obscureText: false,
                  inputType: TextInputType.text
              ),
              const SizedBox(height: 15),
              PteriscopeTextField(
                  controller: _positionController,
                  hintText: 'Cargo',
                  obscureText: false,
                  inputType: TextInputType.text
              ),

              const SizedBox(height: 95),
              PteriscopeElevatedButton(
                  width: MediaQuery.of(context).size.width,
                  enabled: _isButtonDisabled,
                  onTap: _register,
                  text: 'Crear cuenta'
              ),
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
