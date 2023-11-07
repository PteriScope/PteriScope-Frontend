import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPreferencesService?> getInstance() async {
    _instance ??= SharedPreferencesService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  Future<bool?> setLoggedInStatus(bool isLoggedIn) async {
    return await _preferences?.setBool('isLoggedIn', isLoggedIn);
  }

  bool getLoggedInStatus() {
    return _preferences?.getBool('isLoggedIn') ?? false;
  }
}
