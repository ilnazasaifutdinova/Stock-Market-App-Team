import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_market_app/models/stock_data.dart';
import 'package:stock_market_app/models/chart_data_point.dart' show ChartDataPoint;
import 'package:stock_market_app/models/portfolio.dart' hide ChartDataPoint;


extension TimeframeExtension on String {
  int getFromTimestamp() {
    final now = DateTime.now();
    switch (this) {
      case '1W':
        return (now.subtract(const Duration(days: 7)).millisecondsSinceEpoch / 1000).round();
      case '1M':
        return (now.subtract(const Duration(days: 30)).millisecondsSinceEpoch / 1000).round();
      case '3M':
        return (now.subtract(const Duration(days: 90)).millisecondsSinceEpoch / 1000).round();
      case '6M':
        return (now.subtract(const Duration(days: 180)).millisecondsSinceEpoch / 1000).round();
      case '1Y':
        return (now.subtract(const Duration(days: 365)).millisecondsSinceEpoch / 1000).round();
      default:
        return (now.subtract(const Duration(days: 7)).millisecondsSinceEpoch / 1000).round();
    }
  }

  String getResolution() {
    switch (this) {
      case '1W':
        return '60'; // 1 hour intervals
      case '1M':
        return 'D'; // Daily
      case '3M':
        return 'D';
      case '6M':
        return 'W'; // Weekly
      case '1Y':
        return 'W';
      default:
        return 'D';
    }
  }
}

class FinnhubService {
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static const String _apiKey = ''; // Finnhub API key

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

class PortfolioFinnhubService {
  static const String _baseUrl = 'https://finnhub.io/api/v1';
  static const String _apiKey = '';

  // Get real-time quote data
  static Future<StockData> getQuote(String symbol) async {
    try {
      print('Portfolio Service: Fetching quote for symbol: $symbol');

      final response = await http.get(
        Uri.parse('$_baseUrl/quote?symbol=$symbol'),
        headers: {
          'X-Finnhub-Token': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      print('Portfolio Service response for $symbol:');
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return StockData.fromFinnhubJson(data, symbol);
      } else if (response.statusCode == 429) {
        print('Portfolio Service: Rate limit hit, waiting...');
        await Future.delayed(const Duration(seconds: 1));
        return getQuote(symbol);
      } else if (response.statusCode == 403) {
        throw Exception('Portfolio Service: Authentication failed. Please check your API key.');
      } else {
        throw Exception('Portfolio Service: Failed to load quote data: ${response.statusCode}');
      }
    } catch (e) {
      print('Portfolio Service Error: $e');
      throw Exception('Portfolio Service: Error fetching quote data: $e');
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
      print('Portfolio Service: Fetching candles for symbol: $symbol');

      final url = '$_baseUrl/stock/candle?symbol=$symbol&resolution=$resolution&from=$from&to=$to';
      print('Portfolio Service Request URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Finnhub-Token': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      print('Portfolio Service candles response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['s'] == 'no_data') {
          print('Portfolio Service: No data available for the symbol');
          return [];
        }
        return _parseCandles(data);
      } else if (response.statusCode == 429) {
        print('Portfolio Service: Rate limit hit, waiting...');
        await Future.delayed(const Duration(seconds: 1));
        return getCandles(symbol, resolution, from, to);
      } else {
        throw Exception('Portfolio Service: Failed to load candle data: ${response.statusCode}');
      }
    } catch (e) {
      print('Portfolio Service Error in getCandles: $e');
      throw Exception('Portfolio Service: Error fetching candle data: $e');
    }
  }

  // Get historical data with timeframe
  static Future<List<ChartDataPoint>> getHistoricalData(String symbol, String timeframe) async {
    final to = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final from = timeframe.getFromTimestamp();
    final resolution = timeframe.getResolution();

    try {
      print('Portfolio Service: Fetching historical data for $symbol with timeframe: $timeframe');
      return await getCandles(symbol, resolution, from, to);
    } catch (e) {
      print('Portfolio Service Error in getHistoricalData: $e');
      throw Exception('Portfolio Service: Error fetching historical data: $e');
    }
  }

  // Get portfolio history
  static Future<Map<String, List<ChartDataPoint>>> getPortfolioHistory(
      List<Holding> holdings,
      String timeframe,
      ) async {
    Map<String, List<ChartDataPoint>> history = {};

    for (var holding in holdings) {
      try {
        final data = await getHistoricalData(holding.symbol, timeframe);
        history[holding.symbol] = data;
        // Add delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        print('Error fetching history for ${holding.symbol}: $e');
      }
    }

    return history;
  }

  // Helper method to parse candle data
  static List<ChartDataPoint> _parseCandles(Map<String, dynamic> data) {
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
  }

  // Get batch quotes for multiple symbols
  static Future<Map<String, StockData>> getBatchQuotes(List<String> symbols) async {
    Map<String, StockData> results = {};

    for (var symbol in symbols) {
      try {
        results[symbol] = await getQuote(symbol);
        // Add a small delay between requests to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        print('Portfolio Service Error fetching $symbol: $e');
      }
    }

    return results;
  }
}