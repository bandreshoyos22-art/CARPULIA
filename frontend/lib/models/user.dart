class AppUser {
  final String name;
  final String email;
  final String password;
  final String role;

  AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password, 'role': role};
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: (json['role'] as String?)?.toLowerCase() ?? 'pasajero',
    );
  }
}
