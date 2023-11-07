import 'dart:convert';

import 'package:pteriscope_frontend/services/secure_storage_service.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';

import 'api_service.dart';

class AuthenticationService {
  final ApiService apiService;
  final SecureStorageService secureStorageService;
  final SharedPreferencesService sharedPreferencesService;

  AuthenticationService({
    required this.apiService,
    required this.secureStorageService,
    required this.sharedPreferencesService,
  });

  Future<bool> login(String dni, String password) async {
    try {
      final response = await apiService.loginSpecialist(dni, password);
      if (response.statusCode == 200) {
        final jwtToken = jsonDecode(response.body)['token'];
        await secureStorageService.storeToken(jwtToken);
        // Otras configuraciones de inicio de sesión pueden ir aquí, como guardar el estado de la sesión en SharedPreferences.
        return true;
      }
      // Manejar aquí otros códigos de estado y errores
      return false;
    } catch (e) {
      // Manejar excepción
      return false;
    }
  }

  Future<void> logout() async {
    await secureStorageService.deleteToken();
    // Limpiar SharedPreferences si es necesario.
  }

  Future<bool> isLoggedIn() async{
    final token = await secureStorageService.getToken();
    if (token == null){
      return false;
    }
    return true;
  }
}
