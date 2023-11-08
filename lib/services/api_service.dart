import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';
import 'dart:convert';

import '../models/patient.dart';
import '../models/specialist.dart';

class ApiService with ChangeNotifier {
  final String baseUrl = 'http://192.168.0.6:8080/api';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Helper method to get the authorization header
  Future<Map<String, String>> _getAuthHeaders() async {
    String? token = SharedPreferencesService().getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> login(String dni, String password) async {
    log("==================================Login==================================");
    log(dni + password);
    log('$baseUrl/specialists/login');
    log(json.encode({'dni': dni, 'password': password}));
    var response = await http.post(
      Uri.parse('$baseUrl/specialists/login'),
      headers: headers,
      body: json.encode({'dni': dni, 'password': password}),
    );
    log("==================================response==================================");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String token = data['token'];
      log(data["id"].toString());
      int specialistId = data["id"];
      log(token);
      log(specialistId.toString());
      await SharedPreferencesService().setAuthToken(token);
      await SharedPreferencesService().setId(specialistId);
      notifyListeners();
      return true;
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
      notifyListeners();
      return response.body;
    } else {
      throw Exception('Failed to register specialist');
    }
  }

  Future<String> getSpecialist(String specialistId) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/specialists/$specialistId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      notifyListeners();
      return response.body;
    } else {
      throw Exception('Failed to load specialist data');
    }
  }

  Future<List<Patient>> getPatientsFromSpecialist() async {
    log("==================================getPatientsFromSpecialist==================================");
    final specialistId = SharedPreferencesService().getId();
    log(specialistId.toString());
    final headers = await _getAuthHeaders();
    log("==================================before response==================================");
    var response = await http.get(
      Uri.parse('$baseUrl/specialists/$specialistId/patients'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> patientsJson = json.decode(response.body);
      //log(patientsJson as String);
      List<Patient> patients = patientsJson.map((json) => Patient.fromJson(json)).toList();
      notifyListeners();
      return patients;

      //patientResponse = patients;
      //log(patientResponse.length.toString());
      //log(patientResponse[0].dni);


    } else {
      log(response.body);
      throw Exception('Failed to load specialist data');
    }
  }

  Future<String> createPatient(String specialistId, Map<String, dynamic> patientData) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/specialists/$specialistId/patients'),
      headers: headers,
      body: json.encode(patientData),
    );

    if (response.statusCode == 200) {
      notifyListeners();
      return response.body;
    } else {
      throw Exception('Failed to create patient');
    }
  }

  Future<String> getPatient(String patientId) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/patients/$patientId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      notifyListeners();
      return response.body;
    } else {
      throw Exception('Failed to load patient data');
    }
  }

  Future<String> createReview(String patientId, Map<String, dynamic> reviewData) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/reviews?patientId=$patientId'),
      headers: headers,
      body: json.encode(reviewData),
    );

    if (response.statusCode == 200) {
      notifyListeners();
      return response.body;
    } else {
      throw Exception('Failed to create review');
    }
  }

  Future<String> getReview(String reviewId) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/reviews/$reviewId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      notifyListeners();
      return response.body;
    } else {
      throw Exception('Failed to load review data');
    }
  }
}
