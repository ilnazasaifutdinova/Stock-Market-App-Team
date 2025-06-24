import 'package:flutter/material.dart';
import 'package:stock_market_app/services/api_service.dart';

class MarketDataProvider extends ChangeNotifier {
  Map<String, StockData> _stocksData = {};
  List<ChartDataPoint> _chartData = [];
  bool _isLoading = false;
  String? _error;

  Map<String, StockData> get stocksData => _stocksData;
  List<ChartDataPoint> get chartData => _chartData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStockData(String token, String symbol) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.getMarketData(token, symbol);
      _stocksData[symbol] = StockData.fromJson(data);
      _generateChartData(symbol);
    } catch (e) {
      _error = e.toString();
      // Generate mock data if API fails
      _generateMockData(symbol);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _generateChartData(String symbol) {
    final stock = _stocksData[symbol];
    if (stock != null) {
      _chartData = _generateMockChartData(stock.currentPrice);
    }
  }

  void _generateMockData(String symbol) {
    // Generate realistic mock data for demo purposes
    final basePrice = 150.0 + (symbol.hashCode % 100);
    _stocksData[symbol] = StockData(
      symbol: symbol,
      currentPrice: basePrice,
      change: (basePrice * 0.02) * (symbol.hashCode % 2 == 0 ? 1 : -1),
      changePercent: 2.1 * (symbol.hashCode % 2 == 0 ? 1 : -1),
      high: basePrice * 1.05,
      low: basePrice * 0.95,
      open: basePrice * 0.98,
      volume: 1000000 + (symbol.hashCode % 500000),
    );
    _chartData = _generateMockChartData(basePrice);
  }

  List<ChartDataPoint> _generateMockChartData(double basePrice) {
    final List<ChartDataPoint> data = [];
    double price = basePrice;
    
    for (int i = 0; i < 30; i++) {
      // Simulate price movement
      price += (price * 0.02) * (0.5 - (i % 10) / 10.0);
      data.add(ChartDataPoint(
        time: DateTime.now().subtract(Duration(days: 29 - i)),
        price: price,
      ));
    }
    
    return data;
  }

  StockData? getStockData(String symbol) {
    return _stocksData[symbol];
  }
}

class StockData {
  final String symbol;
  final double currentPrice;
  final double change;
  final double changePercent;
  final double high;
  final double low;
  final double open;
  final int volume;

  StockData({
    required this.symbol,
    required this.currentPrice,
    required this.change,
    required this.changePercent,
    required this.high,
    required this.low,
    required this.open,
    required this.volume,
  });

  factory StockData.fromJson(Map<String, dynamic> json) {
    return StockData(
      symbol: json['symbol'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      change: (json['change'] ?? 0).toDouble(),
      changePercent: (json['changePercent'] ?? 0).toDouble(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
      open: (json['open'] ?? 0).toDouble(),
      volume: json['volume'] ?? 0,
    );
  }
}

class ChartDataPoint {
  final DateTime time;
  final double price;

  ChartDataPoint({required this.time, required this.price});
}