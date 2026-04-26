class JoinRequest {
  final String requestId;
  final int viajeId;
  final String pasajeroEmail;
  final int seatsRequested;
  final String status;

  JoinRequest({
    required this.requestId,
    required this.viajeId,
    required this.pasajeroEmail,
    required this.seatsRequested,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'viajeId': viajeId,
      'pasajeroEmail': pasajeroEmail,
      'seatsRequested': seatsRequested,
      'status': status,
    };
  }

  factory JoinRequest.fromJson(Map<String, dynamic> json) {
    return JoinRequest(
      requestId: json['requestId'] as String,
      viajeId: json['viajeId'] as int,
      pasajeroEmail: json['pasajeroEmail'] as String,
      seatsRequested: json['seatsRequested'] as int,
      status: json['status'] as String,
    );
  }
}
