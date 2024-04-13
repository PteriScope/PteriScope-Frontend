import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pteriscope_frontend/models/register_patient.dart';
import 'package:pteriscope_frontend/models/register_user.dart';
import 'package:pteriscope_frontend/services/shared_preferences_service.dart';
import 'dart:convert';

import '../models/patient.dart';
import '../models/review.dart';
import '../models/specialist.dart';

class ApiService with ChangeNotifier {
  //final String baseUrl = 'http://18.212.3.87:8080/api';
  final String baseUrl = 'http://34.207.218.125:8080/api';
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
    }else {
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
      throw Exception('Failed to register specialist');
    }
  }

  Future<Specialist> getSpecialist(int specialistId) async {
    final headers = await _getAuthHeaders();
    var response = await http.get(
      Uri.parse('$baseUrl/specialists/get/$specialistId'),
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
      List<Patient> patients = jsonResponse.map<Patient>((json) => Patient.fromJson(json)).toList();
      notifyListeners();
      return patients;
    } else {
      log(response.body);
      throw Exception('Failed to load specialist data');
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
      List<Review> reviews = jsonResponse.map<Review>((reviewJson) => Review.fromJson(reviewJson)).toList();
      notifyListeners();
      return reviews;
    } else {
      log(response.body);
      throw Exception('Failed to load review data');
    }
  }

  Future<Review> getLatestReviewFromPatient(int patientId) async {
    final headers = await _getAuthHeaders();
    Review latestReview = Review();
    var decodedResponse;
    var jsonResponse;
    var _ = await http.get(
      Uri.parse('$baseUrl/patients/$patientId/latest_reviews'),
      headers: headers
    ).then((value) => {
      if (value.statusCode == 200) {
        decodedResponse = utf8.decode(value.bodyBytes),
        jsonResponse = json.decode(decodedResponse),
        latestReview = Review.fromJson(jsonResponse),
      } else {
        throw Exception('Failed to load latest review')
      }
    });
    return latestReview;
  }

  Future<Patient?> createPatient(RegisterPatient patient) async {
    final specialistId = SharedPreferencesService().getId();
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/specialists/createPatient/$specialistId'),
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

  Future<String> createReview(int patientId, Map<String, dynamic> reviewData) async {
    final headers = await _getAuthHeaders();
    var response = await http.post(
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
