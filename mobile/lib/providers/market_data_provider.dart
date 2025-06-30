import 'package:flutter/material.dart';
import 'package:stock_market_app/services/api_service.dart';
import 'package:stock_market_app/services/finnhub_service.dart';
import 'package:stock_market_app/models/chart_data_point.dart';

class MarketDataProvider extends ChangeNotifier {
  Map<String, StockData> _stocksData = {};
  List<ChartDataPoint> _chartData = [];
  bool _isLoading = false;
  String? _error;

  Map<String, StockData> get stocksData => _stocksData;
  List<ChartDataPoint> get chartData => _chartData;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> fetchStockData(String token, String symbol, [String timeframe = '1M']) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.getMarketData(token, symbol, timeframe);

      // Parse quote data
      final quoteData = data['quote'];
      _stocksData[symbol] = StockData.fromFinnhubJson(quoteData, symbol);

      // Parse candle data
      final candleData = data['candles'];
      if (candleData['s'] == 'ok') {
        final List<dynamic> timestamps = candleData['t'];
        final List<dynamic> prices = candleData['c'];

        _chartData = List.generate(
          timestamps.length,
              (i) => ChartDataPoint(
            time: DateTime.fromMillisecondsSinceEpoch(timestamps[i] * 1000),
            price: prices[i].toDouble(),
          ),
        );
      }
    } catch (e) {
      _error = e.toString();
      // Generate mock data if API fails
      _generateMockData(symbol);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Add a method for fetching historical data
  Future<void> fetchHistoricalData(String symbol, String timeframe) async {
    final now = DateTime.now();
    final int to = (now.millisecondsSinceEpoch / 1000).round();
    int from;
    String resolution;

    switch (timeframe) {
      case '1W':
        from = (now.subtract(const Duration(days: 7)).millisecondsSinceEpoch / 1000).round();
        resolution = '30';
        break;
      case '1M':
        from = (now.subtract(const Duration(days: 30)).millisecondsSinceEpoch / 1000).round();
        resolution = 'D';
        break;
      case '3M':
        from = (now.subtract(const Duration(days: 90)).millisecondsSinceEpoch / 1000).round();
        resolution = 'D';
        break;
      case '6M':
        from = (now.subtract(const Duration(days: 180)).millisecondsSinceEpoch / 1000).round();
        resolution = 'W';
        break;
      case '1Y':
      default:
        from = (now.subtract(const Duration(days: 365)).millisecondsSinceEpoch / 1000).round();
        resolution = 'W';
        break;
    }

    try {
      final candleData = await FinnhubService.getCandles(
        symbol: symbol,
        resolution: resolution,
        from: from,
        to: to,
      );

      if (candleData['s'] == 'ok') {
        final List<dynamic> timestamps = candleData['t'];
        final List<dynamic> prices = candleData['c'];

        _chartData = List.generate(
          timestamps.length,
              (i) => ChartDataPoint(
            time: DateTime.fromMillisecondsSinceEpoch(timestamps[i] * 1000),
            price: prices[i].toDouble(),
          ),
        );

        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      // Fallback to mock data if API fails
      _generateMockChartData(_stocksData[symbol]?.currentPrice ?? 100);
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
    final now = DateTime.now();

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

  factory StockData.fromFinnhubJson(Map<String, dynamic> json, String symbol) {
    return StockData(
      symbol: symbol,
      currentPrice: (json['c'] ?? 0).toDouble(),  // Current price
      change: (json['d'] ?? 0).toDouble(),        // Change
      changePercent: (json['dp'] ?? 0).toDouble(),// Percent change
      high: (json['h'] ?? 0).toDouble(),          // High price of the day
      low: (json['l'] ?? 0).toDouble(),           // Low price of the day
      open: (json['o'] ?? 0).toDouble(),          // Open price of the day
      volume: (json['v'] ?? 0).toInt(),           // Volume
    );
  }
}
