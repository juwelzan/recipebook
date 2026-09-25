import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiColler {
  ApiColler._();

  static final ApiColler instance = ApiColler._();
  final http.Client _client = http.Client();

  Future<dynamic> getData(Uri uri) async {
    try {
      final response = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint('Recipe API returned HTTP ${response.statusCode}');
        throw ApiException(switch (response.statusCode) {
          401 || 403 => 'Recipe service configuration is invalid.',
          >= 500 => 'Recipe service is temporarily unavailable.',
          _ => 'Could not load recipes (HTTP ${response.statusCode}).',
        });
      }
      try {
        return jsonDecode(response.body);
      } on FormatException {
        throw const ApiException('Recipe service returned invalid data.');
      }
    } on ApiException {
      rethrow;
    } on http.ClientException catch (error) {
      // Avoid logging request URIs because Spoonacular credentials are query params.
      debugPrint('Recipe API network error: ${error.runtimeType}');
      throw const ApiException(
        'Could not connect. Check your internet and retry.',
      );
    } on Exception catch (error) {
      debugPrint('Recipe API request failed: ${error.runtimeType}');
      if (error is ApiException) rethrow;
      throw const ApiException('Request timed out. Please retry.');
    }
  }
}
