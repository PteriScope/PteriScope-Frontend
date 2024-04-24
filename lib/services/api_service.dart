import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pteriscope_frontend/models/register_patient.dart';
import 'package:pteriscope_frontend/models/register_user.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';
import 'package:pteriscope_frontend/util/ps_exception.dart';
import 'package:pteriscope_frontend/util/ps_token_exception.dart';
import 'dart:convert';

import '../models/patient.dart';
import '../models/review.dart';
import '../models/specialist.dart';

class ApiService with ChangeNotifier {
  //final String baseUrl = 'http://34.204.84.183:8080/api';
  final String baseUrl = 'http://192.168.1.104:8080/api';
  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  Future<Map<String, String>> _getAuthHeaders() async {
    String? token = SharedPreferencesService().getAuthToken();
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> login(String dni, String password) async {
    log("================================Login================================");
    log('$baseUrl/specialists/login');
    log(json.encode({'dni': dni, 'password': password}));
    var response = await http.post(
      Uri.parse('$baseUrl/specialists/login'),
      headers: headers,
      body: json.encode({'dni': dni, 'password': password}),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String token = data['token'];
      int specialistId = data["id"];
      log(token);
      await SharedPreferencesService().setAuthToken(token);
      await SharedPreferencesService().setId(specialistId);
      notifyListeners();
      return true;
    } else if (response.statusCode == 404) {
      notifyListeners();
      return false;
    } else {
      log(response.statusCode.toString());
      throw Exception('Failed to login');
    }
  }

  Future<bool> registerSpecialist(RegisterUser specialist) async {
    var response = await http.post(
      Uri.parse('$baseUrl/specialists/register'),
      headers: headers,
      body: json.encode(specialist.toJson()),
    );
    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else if (response.statusCode == 404) {
      notifyListeners();
      return false;
    } else {
      var decodedResponse = utf8.decode(response.bodyBytes);
      throw PsException(decodedResponse);
    }
  }

  Future<Specialist> getSpecialist(int specialistId) async {
    final headers = await _getAuthHeaders();
    var response = await http.get(
      Uri.parse('$baseUrl/specialists/$specialistId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(decodedResponse);
      Specialist specialist = Specialist.fromJson(jsonResponse);
      notifyListeners();
      return specialist;
    } else {
      throw Exception('Failed to load specialist data');
    }
  }

  Future<bool> willShowAdvice(int specialistId) async {
    final headers = await _getAuthHeaders();
    var response = await http.get(
      Uri.parse('$baseUrl/specialists/$specialistId/checkShowAdvice'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      bool decodedResponse = jsonDecode(response.body);
      notifyListeners();
      return decodedResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> markDoNotShowAdvice(int specialistId) async {
    final headers = await _getAuthHeaders();
    var response = await http.put(
      Uri.parse('$baseUrl/specialists/$specialistId/markDoNotShowAdvice'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Specialist> updateSpecialist(
      int specialistId, RegisterUser updatedSpecialist) async {
    final headers = await _getAuthHeaders();
    var response = await http.put(
        Uri.parse('$baseUrl/specialists/$specialistId'),
        headers: headers,
        body: json.encode(updatedSpecialist.toJson()));

    if (response.statusCode == 200) {
      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(decodedResponse);
      Specialist specialist = Specialist.fromJson(jsonResponse);
      notifyListeners();
      return specialist;
    } else {
      throw Exception('Failed to update specialist data');
    }
  }

  Future<List<Patient>> getPatientsFromSpecialist() async {
    final specialistId = SharedPreferencesService().getId();
    final headers = await _getAuthHeaders();
    var response = await http.get(
      Uri.parse('$baseUrl/specialists/$specialistId/patients'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(decodedResponse);
      if (jsonResponse is! List) {
        throw Exception('Expected list of reviews');
      }
      List<Patient> patients =
          jsonResponse.map<Patient>((json) => Patient.fromJson(json)).toList();
      notifyListeners();
      return patients;
    } else if (response.statusCode == 401) {
      log(response.body);
      throw PsTokenException("Su sesión ha expirado");
    } else {
      log(response.body);
      throw Exception('Failed to load specialist data');
    }
  }

  Future<Patient?> createPatient(RegisterPatient patient) async {
    final specialistId = SharedPreferencesService().getId();
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/specialists/$specialistId/createPatient'),
      headers: headers,
      body: json.encode(patient.toJson()),
    );

    if (response.statusCode == 200) {
      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(decodedResponse);
      Patient patient = Patient.fromJson(jsonResponse);
      notifyListeners();
      return patient;
    } else {
      return null;
    }
  }

  Future<Patient> updatePatient(
      int patientId, RegisterPatient updatedPatient) async {
    final headers = await _getAuthHeaders();
    var response = await http.put(Uri.parse('$baseUrl/patients/$patientId'),
        headers: headers, body: json.encode(updatedPatient.toJson()));

    if (response.statusCode == 200) {
      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(decodedResponse);
      Patient patient = Patient.fromJson(jsonResponse);
      notifyListeners();
      return patient;
    } else {
      throw Exception('Failed to update patient data');
    }
  }

  Future<void> deletePatient(int patientId) async {
    final headers = await _getAuthHeaders();

    var response = await http.delete(
      Uri.parse('$baseUrl/patients/$patientId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      var decodedResponse = utf8.decode(response.bodyBytes);
      throw PsException(decodedResponse);
    }
  }

  Future<Review> createReview(
      int patientId, Map<String, dynamic> reviewData) async {
    final headers = await _getAuthHeaders();
    var response = await http.post(
      Uri.parse('$baseUrl/reviews?patientId=$patientId'),
      headers: headers,
      body: json.encode(reviewData),
    );

    if (response.statusCode == 200) {
      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(decodedResponse);
      Review review = Review.fromJson(jsonResponse);
      notifyListeners();
      return review;
    } else {
      throw Exception('Failed to create review');
    }
  }

  Future<List<Review>> getReviewsFromPatient(int patientId) async {
    final headers = await _getAuthHeaders();

    var response = await http.get(
      Uri.parse('$baseUrl/patients/$patientId/reviews'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = json.decode(decodedResponse);
      if (jsonResponse is! List) {
        throw Exception('Expected list of reviews');
      }
      List<Review> reviews = jsonResponse
          .map<Review>((reviewJson) => Review.fromJson(reviewJson))
          .toList();
      notifyListeners();
      return reviews;
    } else {
      log(response.body);
      throw Exception('Failed to load review data');
    }
  }

  Future<void> deleteReview(int reviewId) async {
    final headers = await _getAuthHeaders();

    var response = await http.delete(
      Uri.parse('$baseUrl/reviews/$reviewId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      var decodedResponse = utf8.decode(response.bodyBytes);
      throw PsException(decodedResponse);
    }
  }
}
