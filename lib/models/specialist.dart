class Specialist {
  final int id;
  final String name;
  final String dni;
  final String hospital;
  final String position;
  final bool showAdvice;

  Specialist(
      {required this.id,
      required this.name,
      required this.dni,
      required this.hospital,
      required this.position,
      required this.showAdvice});

  factory Specialist.fromJson(Map<String, dynamic> json) {
    return Specialist(
        id: json['id'],
        name: json['name'],
        dni: json['dni'],
        hospital: json['hospital'],
        position: json['position'],
        showAdvice: json['showAdvice']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dni': dni,
      'hospital': hospital,
      'position': position,
    };
  }
}
