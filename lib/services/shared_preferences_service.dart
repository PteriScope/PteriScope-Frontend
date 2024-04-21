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

  Future<bool> setId(int id) async {
    return _prefs?.setInt('id', id) ?? Future.value(false);
  }

  String? getAuthToken() {
    return _prefs?.getString('authToken');
  }

  int? getId() {
    return _prefs?.getInt('id');
  }

  bool isFirstAccessPermission() {
    bool isFirstTime = _prefs?.getBool('firstAccessPermission') ?? true;
    if (isFirstTime) {
      _prefs?.setBool('firstAccessPermission', false);
    }
    return isFirstTime;
  }

  Future<bool> removeId() async {
    return _prefs?.remove('id') ?? Future.value(false);
  }

  Future<bool> removeAuthToken() async {
    return _prefs?.remove('authToken') ?? Future.value(false);
  }

  Future<bool> isLogged() async{
    String? token = _prefs?.getString('authToken');
    return token != null ? true : false;
  }
}
