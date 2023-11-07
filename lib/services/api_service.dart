import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/specialist.dart';

class ApiService {
  final String baseUrl = 'https://tu-dominio-api.com/api';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Helper method to get the authorization header
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String> login(String dni, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/specialists/login'),
      headers: headers,
      body: json.encode({'dni': dni, 'password': password}),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String> registerSpecialist(Specialist specialist) async {
    var response = await http.post(
      Uri.parse('$baseUrl/specialists/register'),
      headers: headers,
      body: json.encode(specialist.toJson()),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to register specialist');
    }
  }

  Future<http.Response> getSpecialist(String specialistId) async {
    final headers = await _getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/specialists/get/$specialistId'),
      headers: headers
    );

    return response;
  }

  Future<http.Response> createPatient(String specialistId, Map<String, dynamic> patientData) async {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/specialists/$specialistId/patients'),
      headers: headers,
      body: json.encode(patientData),
    );

    return response;
  }

  Future<http.Response> getPatient(String patientId) async {
    final headers = await _getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/patients/$patientId'),
      headers: headers,
    );

    return response;
  }

  Future<http.Response> createReview(String patientId, String imageBase64) async {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: headers,
      body: json.encode({
        'patientId': patientId,
        'imageBase64': imageBase64,
      }),
    );

    return response;
  }

  Future<http.Response> getReview(String reviewId) async {
    final headers = await _getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/reviews/$reviewId'),
      headers: headers,
    );

    return response;
  }

}
