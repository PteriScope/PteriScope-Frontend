// login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/authentication/authentication_bloc.dart';
import '../utils/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryLightColor,
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: const Text('Login'),
      ),
      body: BlocProvider(
        create: (context) => AuthenticationBloc(),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí se debe manejar el estado del BLoC y los eventos.
    // Por simplicidad, mostraremos solo la UI básica.

    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) {
                // Agregar lógica para cuando el texto cambie
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                // Agregar lógica para cuando el texto cambie
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Constants.primaryColor),
              ),
              onPressed: () {
                // Agregar lógica para cuando se presione el botón de inicio de sesión
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
