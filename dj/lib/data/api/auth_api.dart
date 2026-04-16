/// Appels REST d’authentification et profil : `/auth/*`, `/user` (GET/PUT).
///
/// Envoie optionnellement `guest_token` à l’inscription / login pour fusion avec la session invitée.
library;

import 'package:dj/data/api/api_client.dart';
import 'package:dj/data/api/auth_store.dart';
import 'package:dj/models/user_model.dart';

class AuthApi {
  final _client = ApiClient.instance;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? guestToken,
  }) async {
    final response = await _client.postJson(
      '/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (guestToken != null) 'guest_token': guestToken,
      },
    );

    final token = response['token']?.toString();
    if (token != null && token.isNotEmpty) {
      await AuthStore.instance.saveToken(token);
    }

    final userRaw = response['user'] as Map<String, dynamic>? ?? {};
    final user = UserModel.fromJson(userRaw);
    await AuthStore.instance.saveRole(user.role);
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
    String? guestToken,
  }) async {
    final response = await _client.postJson(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
        if (guestToken != null) 'guest_token': guestToken,
      },
    );

    final token = response['token']?.toString();
    if (token != null && token.isNotEmpty) {
      await AuthStore.instance.saveToken(token);
    }
    final userRaw = response['user'] as Map<String, dynamic>? ?? {};
    final user = UserModel.fromJson(userRaw);
    await AuthStore.instance.saveRole(user.role);
    return user;
  }

  Future<void> logout() async {
    await _client.postJson('/auth/logout');
    await AuthStore.instance.clear();
  }

  Future<UserModel> me() async {
    final response = await _client.getJson('/user');
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final user = UserModel.fromJson(data);
    await AuthStore.instance.saveRole(user.role);
    return user;
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? locale,
  }) async {
    final response = await _client.putJson(
      '/user',
      body: {
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
        if (locale != null) 'locale': locale,
      },
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(data);
  }
}
