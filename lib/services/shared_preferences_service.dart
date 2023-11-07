import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._privateConstructor();
  static final SharedPreferencesService _instance = SharedPreferencesService._privateConstructor();
  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setAuthToken(String token) async {
    return _prefs?.setString('authToken', token) ?? Future.value(false);
  }

  String? getAuthToken() {
    return _prefs?.getString('authToken');
  }

  Future<bool> removeAuthToken() async {
    return _prefs?.remove('authToken') ?? Future.value(false);
  }

// Puedes agregar más métodos para guardar y recuperar otros tipos de datos según sea necesario.
}
