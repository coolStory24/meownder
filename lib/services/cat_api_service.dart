import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cat.dart';

class CatApiService {
  static const String _apiKey =
      'live_M7VVMPpY8JnMPTIpNXJaKXuQUYbt3jV4l4LnTaZfTudbvHAaFgAg8whzQ3kSQH50';
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
      rethrow;
    }
  }
}
