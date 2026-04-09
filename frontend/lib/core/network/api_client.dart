import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 6);

  Future<dynamic> get(String path) async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl$path'))
          .timeout(_timeout);
      return _decodeResponse(response);
    } on http.ClientException {
      throw ApiException('No se pudo conectar con el servidor.');
    } on TimeoutException {
      throw ApiException('El servidor tardo demasiado en responder.');
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return _decodeResponse(response);
    } on http.ClientException {
      throw ApiException('No se pudo conectar con el servidor.');
    } on TimeoutException {
      throw ApiException('El servidor tardo demasiado en responder.');
    }
  }

  dynamic _decodeResponse(http.Response response) {
    final jsonBody = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonBody;
    }

    final message = jsonBody is Map<String, dynamic>
        ? jsonBody['message']?.toString() ?? 'Error desconocido'
        : 'Error desconocido';
    throw ApiException(message);
  }
}
