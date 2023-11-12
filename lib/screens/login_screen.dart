import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pteriscope_frontend/screens/registration_screen.dart';
import 'package:pteriscope_frontend/services/api_service.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_elevated_button.dart';
import 'package:pteriscope_frontend/widgets/pteriscope_text_field.dart';

import '../util/constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _dniController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
  }

  void _checkFields() {
    if (_dniController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      if (!_isButtonDisabled) return;
      setState(() => _isButtonDisabled = false);
    } else {
      if (_isButtonDisabled) return;
      setState(() => _isButtonDisabled = true);
    }
  }

  void _login() async {
    // TODO: Disable Login Button
    var apiService = Provider.of<ApiService>(context, listen: false);
    bool loggedIn = await apiService.login(
        _dniController.text, _passwordController.text
    );
    if (loggedIn) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen())
      );
    } else {
      // Show error message
    }
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
            const Text(
                'Bienvenido',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                )
            ),
            const SizedBox(height: 20),
            PteriscopeTextField(
                controller: _dniController,
                hintText: 'DNI',
                obscureText: false,
                inputType: TextInputType.number
            ),
            const SizedBox(height: 20),
            PteriscopeTextField(
                controller: _passwordController,
                hintText: 'Contraseña',
                obscureText: true,
                inputType: TextInputType.text
            ),
            const SizedBox(height: 20),

            PteriscopeElevatedButton(
                width: MediaQuery.of(context).size.width,
                enabled: _isButtonDisabled,
                onTap: _login,
                text: 'Ingresar'
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const RegistrationScreen()
                ));
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
