import 'package:pteriscope_frontend/services/secure_storage_service.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';

class AuthenticationService {
  final SharedPreferencesService? _prefsService = SharedPreferencesService.getInstance() as SharedPreferencesService?;
  final SecureStorageService _secureStorageService = SecureStorageService();


  Future<bool> login(String dni, String password) async {
    // Simula la lógica de autenticación
    // En un escenario real, aquí enviarías los datos al backend y guardarías el token de sesión si es exitoso
    bool loginSuccess = true; // Simula una respuesta exitosa

    if (loginSuccess) {
      // Si el login es exitoso, guardamos el estado de sesión como 'true'
      await _prefsService?.setLoggedInStatus(true);
      await _secureStorageService.setToken(jwtToken);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    // Lógica para cerrar sesión
    await _secureStorageService.setToken('');
    await _prefsService?.setLoggedInStatus(false);
  }

  Future<bool?> checkLoggedInStatus() async {
    return _prefsService?.getLoggedInStatus();
  }
}
