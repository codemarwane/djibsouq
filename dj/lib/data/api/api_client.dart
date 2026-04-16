/// Client HTTP unique pour l’app : Dio avec timeouts, JSON, et en-têtes d’auth.
///
/// [String.fromEnvironment] `API_BASE_URL` surcharge l’URL par défaut (`127.0.0.1:8000/api`).
/// Chaque requête ajoute `Authorization: Bearer …` si un token est enregistré, et
/// `X-Guest-Token` pour le panier / favoris invité.
library;

import 'package:dio/dio.dart';
import 'package:dj/data/api/api_exception.dart';
import 'package:dj/data/api/auth_store.dart';
import 'package:dj/data/api/guest_token_store.dart';

class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    // Injection session utilisateur + invité avant chaque appel réseau.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await AuthStore.instance.init();
          await GuestTokenStore.instance.init();

          final token = AuthStore.instance.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          final guestToken = GuestTokenStore.instance.guestToken;
          if (guestToken != null && guestToken.isNotEmpty) {
            options.headers['X-Guest-Token'] = guestToken;
          }

          handler.next(options);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();
  late final Dio _dio;

  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {'data': data};
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.post<dynamic>(path, data: body);
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {'data': data};
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }

  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.put<dynamic>(path, data: body);
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {'data': data};
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }

  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(path, data: body);
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {'data': data};
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }

  Future<Map<String, dynamic>> deleteJson(String path) async {
    try {
      final response = await _dio.delete<dynamic>(path);
      final data = response.data;
      if (data is Map<String, dynamic>) return data;
      return {'data': data};
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    }
  }
}
