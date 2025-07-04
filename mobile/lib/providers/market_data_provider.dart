import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:stock_market_app/services/finnhub_service.dart';
import 'package:stock_market_app/models/chart_data_point.dart';
import 'package:stock_market_app/models/stock_data.dart';

class MarketDataProvider extends ChangeNotifier {
  final _stocksData = <String, StockData>{};
  final _chartData = <ChartDataPoint>[];
  String? _error;

  Map<String, StockData> get stocksData => _stocksData;
  List<ChartDataPoint> get chartData => _chartData;
  String? get error => _error;

  // A map to track loading state per symbol
  final Map<String, bool> _loadingStates = {};

  // the isLoading getter
  bool get isLoading => _loadingStates.values.any((loading) => loading);

  // A method to check if specific symbol is loading
  bool isSymbolLoading(String symbol) => _loadingStates[symbol] ?? false;

  // Rate limiting
  static const _rateLimitDelay = Duration(milliseconds: 100);
  final _lastApiCall = <String, DateTime>{};

  // Caching
  static const _cacheExpiration = Duration(minutes: 15);
  final _lastUpdateTime = <String, DateTime>{};

  // Rate limiting helper
  Future<void> _checkRateLimit(String symbol) async {
    final lastCall = _lastApiCall[symbol];
    if (lastCall != null) {
      final timeSinceLastCall = DateTime.now().difference(lastCall);
      if (timeSinceLastCall < _rateLimitDelay) {
        await Future.delayed(_rateLimitDelay - timeSinceLastCall);
      }
    }
    _lastApiCall[symbol] = DateTime.now();
  }

  // Caching helper
  bool _isCacheValid(String symbol) {
    final lastUpdate = _lastUpdateTime[symbol];
    if (lastUpdate == null) return false;
    return DateTime.now().difference(lastUpdate) < _cacheExpiration;
  }

  Future<void> fetchStockData(String symbol, String timeframe) async {
    try {
      if (!_isCacheValid(symbol)) {
        _loadingStates[symbol] = true;
        notifyListeners();

        await _checkRateLimit(symbol);  // Respect API rate limits
        final data = await FinnhubService.getQuote(symbol);

        _stocksData[symbol] = data;
        _lastUpdateTime[symbol] = DateTime.now();

        //_isLoading = false;
        _loadingStates[symbol] = false;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching $symbol: $e');
      _error = 'Error fetching $symbol: ${e.toString()}';
      _loadingStates[symbol] = false;
      notifyListeners();
    }
  }

// A method for fetching historical data
  Future<void> fetchHistoricalData(String symbol, String timeframe) async {
    try {
      final resolution = _getResolution(timeframe);
      final from = _getFromDate(timeframe);
      final to = DateTime.now();

      final data = await FinnhubService.getCandles(
        symbol,
        resolution,
        from.millisecondsSinceEpoch ~/ 1000,
        to.millisecondsSinceEpoch ~/ 1000,
      );

      _chartData.clear();
      _chartData.addAll(data);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  String _getResolution(String timeframe) {
    switch (timeframe) {
      case '1W': return '30';
      case '1M': return 'D';
      case '3M': return 'D';
      case '6M': return 'W';
      case '1Y': return 'W';
      default: return 'D';
    }
  }

  DateTime _getFromDate(String timeframe) {
    final now = DateTime.now();
    switch (timeframe) {
      case '1W': return now.subtract(const Duration(days: 7));
      case '1M': return now.subtract(const Duration(days: 30));
      case '3M': return now.subtract(const Duration(days: 90));
      case '6M': return now.subtract(const Duration(days: 180));
      case '1Y': return now.subtract(const Duration(days: 365));
      default: return now.subtract(const Duration(days: 30));
    }
  }

  StockData? getStockData(String symbol) {
    return _stocksData[symbol];
  }
}
