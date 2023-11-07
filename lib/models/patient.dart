class Patient {
  final int id;
  final String firstName;
  final String lastName;
  final String dni;
  final int age;
  final String email;
  final int specialistId;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.age,
    required this.email,
    required this.specialistId,
  });

  // Método para convertir un objeto JSON en un objeto Patient
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dni: json['dni'],
      age: json['age'],
      email: json['email'],
      specialistId: json['specialistId'],
    );
  }

  // Método para convertir un objeto Patient en un objeto JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'age': age,
      'email': email,
      'specialistId': specialistId,
    };
  }
}
