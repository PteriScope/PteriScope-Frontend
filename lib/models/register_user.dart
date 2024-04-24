class RegisterUser {
  final String name;
  final String dni;
  final String password;
  final String hospital;
  final String position;

  RegisterUser(
      {required this.name,
      required this.dni,
      required this.password,
      required this.hospital,
      required this.position});

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      name: json['name'],
      dni: json['dni'],
      password: json['password'],
      hospital: json['hospital'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dni': dni,
      'password': password,
      'hospital': hospital,
      'position': position,
    };
  }
}
