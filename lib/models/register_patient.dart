import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:pteriscope_frontend/models/review.dart';

class RegisterPatient {
  final String firstName;
  final String lastName;
  final String dni;
  final int age;
  final String email;

  RegisterPatient({
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.age,
    required this.email
  });

  // Método para convertir un objeto JSON en un objeto Patient
  factory RegisterPatient.fromJson(Map<String, dynamic> json) {
    log("===========Patient============");
    return RegisterPatient(
      firstName: json['firstName'],
      lastName: json['lastName'],
      dni: json['dni'],
      age: json['age'],
      email: json['email']
    );
  }

  // Método para convertir un objeto Patient en un objeto JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'age': age,
      'email': email,
    };
  }
}
