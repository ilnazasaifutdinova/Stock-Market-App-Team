import 'dart:convert';
import 'package:http/http.dart' as http;

class FinnhubService {
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static const String _apiKey = 'd1hc1epr01qsvr297i60d1hc1epr01qsvr297i6g'; // Finnhub API key

  // Get real-time quote data
  static Future<Map<String, dynamic>> getQuote(String symbol) async {
    final uri = Uri.parse('$_baseUrl/quote?symbol=$symbol&token=$_apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch quote: ${response.body}');
    }
  }

  // Get company profile
  static Future<Map<String, dynamic>> getCompanyProfile(String symbol) async {
    final uri = Uri.parse('$_baseUrl/stock/profile2?symbol=$symbol&token=$_apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch company profile: ${response.body}');
    }
  }

  // Get historical candle data
  static Future<Map<String, dynamic>> getCandles({
    required String symbol,
    required String resolution,
    required int from,
    required int to,
  }) async {
    final uri = Uri.parse(
        '$_baseUrl/stock/candle?symbol=$symbol&resolution=$resolution&from=$from&to=$to&token=$_apiKey'
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch candles: ${response.body}');
    }
  }

  // Get symbol lookup
  static Future<List<dynamic>> symbolLookup(String query) async {
    final uri = Uri.parse('$_baseUrl/search?q=$query&token=$_apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'] as List<dynamic>;
    } else {
      throw Exception('Failed to search symbols: ${response.body}');
    }
  }
}