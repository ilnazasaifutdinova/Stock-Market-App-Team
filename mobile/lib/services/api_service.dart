import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // For Android Emulator: 10.0.2.2;
  // For iOS-Emulator or macOS-version you allow to use http://localhost:4000
  static const String _baseUrl = 'http://10.0.2.2:4000/api';

  /// Login and return accessToken
  static Future<String> login(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['accessToken'] as String;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  /// Register, return true, if status 201
  static Future<bool> register(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return response.statusCode == 201;
  }

  /// Get a list of user's Portfolios, if status not 200
  static Future<List<dynamic>> getPortfolios(String token) async {
    final uri = Uri.parse('$_baseUrl/portfolios');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch portfolios: ${response.body}');
    }
  }

  /// Get specific stock data (symbol); return JSON-object
  static Future<Map<String, dynamic>> getMarketData(String token, String symbol, [String timeframe = '1M']) async {
    // Consider whether you still need this method or if it should be modified
    // to work with Finnhub data
    final uri = Uri.parse('$_baseUrl/marketdata/$symbol?timeframe=$timeframe');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch market data: ${response.body}');
    }
  }
}
