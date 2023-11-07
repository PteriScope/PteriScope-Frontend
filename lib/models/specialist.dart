class Specialist {
  final int id;
  final String name;
  final String dni;
  final String hospital;
  final String position;

  Specialist({
    required this.id,
    required this.name,
    required this.dni,
    required this.hospital,
    required this.position
  });

  factory Specialist.fromJson(Map<String, dynamic> json) {
    return Specialist(
      id: json['id'],
      name: json['name'],
      dni: json['dni'],
      hospital: json['hospital'],
      position: json['position'],
    );
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
