class Vehiculo {
  final String id;
  final String conductorEmail;
  final String marca;
  final String modelo;
  final String color;
  final String placa;
  final int cupos;

  Vehiculo({
    required this.id,
    required this.conductorEmail,
    required this.marca,
    required this.modelo,
    required this.color,
    required this.placa,
    required this.cupos,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conductor_email': conductorEmail,
      'marca': marca,
      'modelo': modelo,
      'color': color,
      'placa': placa,
      'cupos': cupos,
    };
  }

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'] as String,
      conductorEmail: json['conductor_email'] as String,
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      color: json['color'] as String,
      placa: json['placa'] as String,
      cupos: json['cupos'] as int,
    );
  }
}
