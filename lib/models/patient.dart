import 'package:intl/intl.dart';

class Patient {
  final int id;
  final String firstName;
  final String lastName;
  final String dni;
  final int age;
  final String email;
  final int specialistId;
  final String? lastReviewResult;
  final DateTime? lastReviewDate;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.age,
    required this.email,
    required this.specialistId,
    this.lastReviewResult,
    this.lastReviewDate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dni: json['dni'],
      age: json['age'],
      email: json['email'],
      specialistId: json['specialistId'],
      lastReviewResult: json['lastReviewResult'],
      lastReviewDate: json['lastReviewDate'] == null
          ? null
          : DateFormat("yyyy-MM-dd").parse(json['lastReviewDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'age': age,
      'email': email,
      'specialistId': specialistId,
      'reviewResult': lastReviewResult,
      'reviewDate': DateFormat("yyyy-MM-dd").format(lastReviewDate!),
    };
  }
}
