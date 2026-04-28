class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    required this.message,
    this.errors,
  });

  final int? statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  factory ApiException.fromResponse({
    required int? statusCode,
    required dynamic data,
  }) {
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString() ?? 'Erreur API.';
      final errors = data['errors'] is Map<String, dynamic>
          ? data['errors'] as Map<String, dynamic>
          : null;
      return ApiException(statusCode: statusCode, message: message, errors: errors);
    }

    return ApiException(
      statusCode: statusCode,
      message: 'Erreur réseau inattendue.',
    );
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
