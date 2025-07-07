import 'package:flutter/material.dart';
import 'package:stock_market_app/services/finnhub_service.dart';
import 'package:stock_market_app/models/chart_data_point.dart';
import 'package:stock_market_app/models/stock_data.dart';

class MarketDataProvider extends ChangeNotifier {
  final Map<String, StockData> _stocksData = {};
  final List<ChartDataPoint> _chartData = [];
  String? _error;

  // Loading states per symbol
  final Map<String, bool> _loadingStates = {};

  // Getters
  Map<String, StockData> get stocksData => _stocksData;
  List<ChartDataPoint> get chartData => _chartData;
  String? get error => _error;
  bool get isLoading => _loadingStates.values.any((loading) => loading);

  bool isSymbolLoading(String symbol) => _loadingStates[symbol] ?? false;

  // --- Stock Quote Fetching ---

  Future fetchStockData(String symbol, String timeframe) async {
    try {
      _loadingStates[symbol] = true;
      notifyListeners();
      final data = await FinnhubService.getQuote(symbol);
      _stocksData[symbol] = data;
      _loadingStates[symbol] = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error fetching $symbol: ${e.toString()}';
      _loadingStates[symbol] = false;
      notifyListeners();
    }
  }

  StockData? getStockData(String symbol) {
    return _stocksData[symbol];
  }

  // --- Historical Chart Data (Line Chart) ---

  Future fetchHistoricalData(String symbol, String timeframe) async {
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


  // --- Helper Methods for Timeframes ---

  String _getResolution(String timeframe) {
    switch (timeframe) {
      case '1D':
        return '1'; // 1-minute intervals for intraday
      case '1W':
        return '30'; // 30-min intervals
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

  DateTime _getFromDate(String timeframe) {
    final now = DateTime.now();
    switch (timeframe) {
      case '1D':
        return now.subtract(const Duration(days: 1));
      case '1W':
        return now.subtract(const Duration(days: 7));
      case '1M':
        return now.subtract(const Duration(days: 30));
      case '3M':
        return now.subtract(const Duration(days: 90));
      case '6M':
        return now.subtract(const Duration(days: 180));
      case '1Y':
        return now.subtract(const Duration(days: 365));
      default:
        return now.subtract(const Duration(days: 30));
        
    }
  }
}
