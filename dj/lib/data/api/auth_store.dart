/// Persistance locale du jeton Sanctum et du rôle utilisateur après login / register.
library;

import 'package:shared_preferences/shared_preferences.dart';

class AuthStore {
  static const _tokenKey = 'auth_token';
  static const _userRoleKey = 'auth_user_role';

  static final AuthStore instance = AuthStore._();
  AuthStore._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  String? get token => _prefs?.getString(_tokenKey);
  String? get role => _prefs?.getString(_userRoleKey);

  bool get isAuthenticated => (token ?? '').isNotEmpty;

  Future<void> saveToken(String value) async {
    await init();
    await _prefs!.setString(_tokenKey, value);
  }

  Future<void> saveRole(String? value) async {
    await init();
    if (value == null || value.isEmpty) {
      await _prefs!.remove(_userRoleKey);
      return;
    }
    await _prefs!.setString(_userRoleKey, value);
  }

  Future<void> clear() async {
    await init();
    await _prefs!.remove(_tokenKey);
    await _prefs!.remove(_userRoleKey);
  }
}
