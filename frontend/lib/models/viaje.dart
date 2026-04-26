class Viaje {
  final int? id;
  final int vehiculo;
  final String conductorEmail;
  final String origen;
  final String destino;
  final String? origenLat;
  final String? origenLng;
  final String? destinoLat;
  final String? destinoLng;
  final String fecha;
  final String horaSalida;
  int cuposDisponibles;
  final double precio;
  final bool isLocal;

  Viaje({
    this.id,
    required this.vehiculo,
    required this.conductorEmail,
    required this.origen,
    required this.destino,
    this.origenLat,
    this.origenLng,
    this.destinoLat,
    this.destinoLng,
    required this.fecha,
    required this.horaSalida,
    required this.cuposDisponibles,
    required this.precio,
    this.isLocal = false,
  });

  factory Viaje.fromJson(Map<String, dynamic> json) {
    return Viaje(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      vehiculo: json['vehiculo'] is int
          ? json['vehiculo'] as int
          : int.parse('${json['vehiculo'] ?? 1}'),
      conductorEmail: json['conductor_email'] as String? ?? '',
      origen: json['origen'] as String? ?? '',
      destino: json['destino'] as String? ?? '',
      origenLat: json['origen_lat']?.toString(),
      origenLng: json['origen_lng']?.toString(),
      destinoLat: json['destino_lat']?.toString(),
      destinoLng: json['destino_lng']?.toString(),
      fecha: json['fecha'] as String? ?? '',
      horaSalida: json['hora_salida'] as String? ?? '',
      cuposDisponibles: json['cupos_disponibles'] is int
          ? json['cupos_disponibles'] as int
          : int.tryParse('${json['cupos_disponibles']}') ?? 0,
      precio: json['precio'] is double
          ? json['precio'] as double
          : double.tryParse('${json['precio']}') ?? 0.0,
      isLocal: json['isLocal'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'vehiculo': vehiculo,
      'conductor_email': conductorEmail,
      'origen': origen,
      'destino': destino,
      if (origenLat != null) 'origen_lat': origenLat,
      if (origenLng != null) 'origen_lng': origenLng,
      if (destinoLat != null) 'destino_lat': destinoLat,
      if (destinoLng != null) 'destino_lng': destinoLng,
      'fecha': fecha,
      'hora_salida': horaSalida,
      'cupos_disponibles': cuposDisponibles,
      'precio': precio,
      'isLocal': isLocal,
    };
  }

  Viaje copyWith({
    int? id,
    int? vehiculo,
    String? conductorEmail,
    String? origen,
    String? destino,
    String? origenLat,
    String? origenLng,
    String? destinoLat,
    String? destinoLng,
    String? fecha,
    String? horaSalida,
    int? cuposDisponibles,
    double? precio,
    bool? isLocal,
  }) {
    return Viaje(
      id: id ?? this.id,
      vehiculo: vehiculo ?? this.vehiculo,
      conductorEmail: conductorEmail ?? this.conductorEmail,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      origenLat: origenLat ?? this.origenLat,
      origenLng: origenLng ?? this.origenLng,
      destinoLat: destinoLat ?? this.destinoLat,
      destinoLng: destinoLng ?? this.destinoLng,
      fecha: fecha ?? this.fecha,
      horaSalida: horaSalida ?? this.horaSalida,
      cuposDisponibles: cuposDisponibles ?? this.cuposDisponibles,
      precio: precio ?? this.precio,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}
