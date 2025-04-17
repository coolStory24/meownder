import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CatApiService {
  static final String _apiKey = dotenv.get('API_KEY', fallback: "empty-key");
  static const String _baseUrl = 'https://api.thecatapi.com/v1/images/search';

  Future<Cat> fetchRandomCat() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?has_breeds=1'),
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        return Cat.fromJson(jsonDecode(response.body)[0]);
      } else {
        throw Exception('Failed to load cat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
