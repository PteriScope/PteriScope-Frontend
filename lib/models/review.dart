import 'package:intl/intl.dart';

class Review {
  final int id;
  final String imageBase64;
  final String reviewResult;
  final DateTime reviewDate;
  final int patientId;

  Review({
    required this.id,
    required this.imageBase64,
    required this.reviewResult,
    required this.reviewDate,
    required this.patientId,
  });

  // Método para convertir un objeto JSON en un objeto Review
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      imageBase64: json['imageBase64'],
      reviewResult: json['reviewResult'],
      reviewDate: DateFormat("yyyy-MM-dd").parse(json['reviewDate']),
      patientId: json['patientId'],
    );
  }

  // Método para convertir un objeto Review en un objeto JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageBase64': imageBase64,
      'reviewResult': reviewResult,
      'reviewDate': DateFormat("yyyy-MM-dd").format(reviewDate),
      'patientId': patientId,
    };
  }
}
