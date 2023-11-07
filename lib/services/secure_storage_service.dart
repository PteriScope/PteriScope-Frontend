import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> setToken(String token) async {
    await _storage.write(key: 'jwtToken', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwtToken');
  }
}
