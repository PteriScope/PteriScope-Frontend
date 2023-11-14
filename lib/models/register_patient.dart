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

  factory RegisterPatient.fromJson(Map<String, dynamic> json) {
    return RegisterPatient(
      firstName: json['firstName'],
      lastName: json['lastName'],
      dni: json['dni'],
      age: json['age'],
      email: json['email']
    );
  }

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
