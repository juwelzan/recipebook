import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiColler {
  ApiColler._();

  static final ApiColler instance = ApiColler._();

  Future<dynamic> getData(String url) async {
    debugPrint('Fetching data from API...');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint('Failed to load data: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      debugPrint('Error occurred: $e');
      return null;
    }
  }
}
