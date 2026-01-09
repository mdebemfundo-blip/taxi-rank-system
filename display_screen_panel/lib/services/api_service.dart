import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  // ROUTES
  static Future<List> getRoutes() async {
    final res = await http.get(Uri.parse('$baseUrl/api/routes'));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load routes');
    }
  }

  static Future<void> updateRoute(String id, Map<String, dynamic> data) async {
    await http.put(
      Uri.parse("$baseUrl/routes/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  static Future<void> addRoute(Map<String, dynamic> data) async {
    await http.post(
      Uri.parse("$baseUrl/routes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  // ADVERTS
  static Future<List> getAdverts() async {
    final res = await http.get(Uri.parse('$baseUrl/api/adverts'));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.body); // 👈 DEBUG HTML ERRORS
      return [];
    }
  }
}
