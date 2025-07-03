import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_market_app/models/stock_data.dart';
import 'package:stock_market_app/models/chart_data_point.dart';

class FinnhubService {
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static const String _apiKey = 'd1jbpipr01qkl9jbai10d1jbpipr01qkl9jbai1g'; // Finnhub API key

  // Get real-time quote data
  static Future<StockData> getQuote(String symbol) async {
    try {
      print('Fetching quote for symbol: $symbol'); // Debug log

      final response = await http.get(
        Uri.parse('$_baseUrl/quote?symbol=$symbol'),
        headers: {
          'X-Finnhub-Token': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      print('Response for $symbol:');
      print('Status code: ${response.statusCode}'); // Debug log
      print('Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return StockData.fromFinnhubJson(data, symbol);
      } else if (response.statusCode == 403) {
        throw Exception('Authentication failed. Please check your API key.');
      } else {
        throw Exception('Failed to load quote data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getQuote: $e'); // Debug log
      throw Exception('Error fetching quote data: $e');
    }
  }

  // Get company profile
  static Future<Map<String, dynamic>> getCompanyProfile(String symbol) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stock/profile2?symbol=$symbol'),
      headers: {'X-Finnhub-Token': _apiKey},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load company profile: ${response.statusCode}');
    }
  }

  // Get historical candle data
  static Future<List<ChartDataPoint>> getCandles(
      String symbol,
      String resolution,
      int from,
      int to,
      ) async {
    try {
      print('Fetching candles for symbol: $symbol'); // Debug log

      final url = '$_baseUrl/stock/candle?symbol=$symbol&resolution=$resolution&from=$from&to=$to';
      print('Request URL: $url'); // Debug log

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Finnhub-Token': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['s'] == 'no_data') {
          print('No data available for the symbol'); // Debug log
          return [];
        }

        List<ChartDataPoint> candles = [];
        final timestamps = data['t'] as List;
        final prices = data['c'] as List;

        for (var i = 0; i < timestamps.length; i++) {
          candles.add(ChartDataPoint(
            time: DateTime.fromMillisecondsSinceEpoch(timestamps[i] * 1000),
            price: prices[i].toDouble(),
          ));
        }

        return candles;
      } else if (response.statusCode == 403) {
        print('API Key being used: $_apiKey'); // temporary debug line
        throw Exception('Authentication failed. Please check your API key.');
      } else {
        throw Exception('Failed to load candle data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getCandles: $e'); // Debug log
      throw Exception('Error fetching candle data: $e');
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