import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:8080/api";

  // Headers básicos para Content-Type y Accept
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Headers con Autorización, necesitarás el token JWT aquí.
  Map<String, String> _getAuthHeaders(String token) {
    return {
      ..._getHeaders(),
      'Authorization': 'Bearer $token',
    };
  }

  // Especialistas
  Future<http.Response> registerSpecialist(Map<String, dynamic> data) {
    var url = Uri.parse('$baseUrl/specialists/register');
    return http.post(url, headers: _getHeaders(), body: json.encode(data));
  }

  Future<http.Response> loginSpecialist(Map<String, dynamic> data) {
    var url = Uri.parse('$baseUrl/specialists/login');
    return http.post(url, headers: _getHeaders(), body: json.encode(data));
  }

  Future<http.Response> getSpecialist(String token, int specialistId) {
    var url = Uri.parse('$baseUrl/specialists/get/$specialistId');
    return http.get(url, headers: _getAuthHeaders(token));
  }

  // Pacientes
  Future<http.Response> createPatient(String token, Map<String, dynamic> data, int specialistId) {
    var url = Uri.parse('$baseUrl/specialists/$specialistId/patients');
    return http.post(url, headers: _getAuthHeaders(token), body: json.encode(data));
  }

  Future<http.Response> getPatient(String token, int patientId) {
    var url = Uri.parse('$baseUrl/patients/get/$patientId');
    return http.get(url, headers: _getAuthHeaders(token));
  }

  Future<http.Response> updatePatient(String token, int patientId, Map<String, dynamic> data) {
    var url = Uri.parse('$baseUrl/patients/update/$patientId');
    return http.put(url, headers: _getAuthHeaders(token), body: json.encode(data));
  }

  Future<http.Response> deletePatient(String token, int patientId) {
    var url = Uri.parse('$baseUrl/patients/delete/$patientId');
    return http.delete(url, headers: _getAuthHeaders(token));
  }

  // Revisiones
  Future<http.Response> createReview(String token, int patientId, String imageBase64) {
    var url = Uri.parse('$baseUrl/reviews');
    var data = {
      'patientId': patientId.toString(),
      'imageBase64': imageBase64,
    };
    return http.post(url, headers: _getAuthHeaders(token), body: json.encode(data));
  }

  Future<http.Response> getReview(String token, int reviewId) {
    var url = Uri.parse('$baseUrl/reviews/$reviewId');
    return http.get(url, headers: _getAuthHeaders(token));
  }

// Aquí puedes agregar métodos adicionales según necesites

}
