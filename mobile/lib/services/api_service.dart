// mobile/lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Для Android-эмулятора: 10.0.2.2;
  // Для iOS-симулятора или macOS-версии можно использовать http://localhost:4000
  static const String _baseUrl = 'http://10.0.2.2:4000/api';

  /// Выполняет логин и возвращает accessToken
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

  /// Выполняет регистрацию; возвращает true, если статус 201
  static Future<bool> register(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return response.statusCode == 201;
  }

  /// Получает список портфелей пользователя; выбрасывает, если не 200
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

  /// Получает данные по конкретной акции (symbol); возвращает JSON-объект
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
