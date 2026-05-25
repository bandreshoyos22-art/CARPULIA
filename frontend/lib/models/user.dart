class AppUser {
  final String name;
  final String email;
  final String password;
  final String role;
  final String phone;

  AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phone = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: (json['role'] as String?)?.toLowerCase() ?? 'pasajero',
      phone: json['phone'] as String? ?? '',
    );
  }
}
