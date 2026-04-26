import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/solicitud.dart';
import '../models/user.dart';
import '../models/viaje.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() => _instance;

  StorageService._internal();

  late SharedPreferences _prefs;
  AppUser? currentUser;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    currentUser = await loadCurrentUser();
  }

  Future<AppUser?> loadCurrentUser() async {
    final userJson = _prefs.getString('uniride_current_user');
    if (userJson == null) return null;
    try {
      return AppUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCurrentUser(AppUser user) async {
    currentUser = user;
    await _prefs.setString('uniride_current_user', jsonEncode(user.toJson()));
  }

  Future<void> clearCurrentUser() async {
    currentUser = null;
    await _prefs.remove('uniride_current_user');
  }

  Future<List<AppUser>> loadUsers() async {
    final usersJson = _prefs.getString('uniride_users');
    if (usersJson == null) return <AppUser>[];
    final list = jsonDecode(usersJson) as List<dynamic>;
    return list.map((item) => AppUser.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveUsers(List<AppUser> users) async {
    final encoded = jsonEncode(users.map((u) => u.toJson()).toList());
    await _prefs.setString('uniride_users', encoded);
  }

  Future<List<Viaje>> loadLocalTrips() async {
    final viajesJson = _prefs.getString('uniride_local_viajes');
    if (viajesJson == null) return <Viaje>[];
    final list = jsonDecode(viajesJson) as List<dynamic>;
    return list.map((item) => Viaje.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveLocalTrips(List<Viaje> viajes) async {
    final encoded = jsonEncode(viajes.map((v) => v.toJson()).toList());
    await _prefs.setString('uniride_local_viajes', encoded);
  }

  Future<List<JoinRequest>> loadRequests() async {
    final jsonString = _prefs.getString('uniride_join_requests');
    if (jsonString == null) return <JoinRequest>[];
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list.map((item) => JoinRequest.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveRequests(List<JoinRequest> requests) async {
    final encoded = jsonEncode(requests.map((r) => r.toJson()).toList());
    await _prefs.setString('uniride_join_requests', encoded);
  }
}
