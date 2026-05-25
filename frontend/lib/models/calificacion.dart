class Calificacion {
  final String id;
  final String viajeId;
  final String conductorEmail;
  final String pasajeroEmail;
  final int score;
  final String comment;
  final DateTime createdAt;

  Calificacion({
    required this.id,
    required this.viajeId,
    required this.conductorEmail,
    required this.pasajeroEmail,
    required this.score,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'viaje_id': viajeId,
      'conductor_email': conductorEmail,
      'pasajero_email': pasajeroEmail,
      'score': score,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Calificacion.fromJson(Map<String, dynamic> json) {
    return Calificacion(
      id: json['id'] as String,
      viajeId: json['viaje_id'] as String,
      conductorEmail: json['conductor_email'] as String,
      pasajeroEmail: json['pasajero_email'] as String,
      score: json['score'] as int,
      comment: json['comment'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
