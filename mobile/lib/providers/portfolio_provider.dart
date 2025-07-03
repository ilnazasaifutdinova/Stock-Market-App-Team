import 'package:flutter/material.dart';
import 'package:stock_market_app/services/api_service.dart';
import 'package:stock_market_app/models/portfolio.dart';

class PortfolioProvider extends ChangeNotifier {
  List<Portfolio> _portfolios = [];
  double _totalValue = 12345.67;
  double _overallPerformance = 2.5;
  bool _isLoading = false;
  String? _error;

  List<Portfolio> get portfolios => _portfolios;
  double get totalValue => _totalValue;
  double get overallPerformance => _overallPerformance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPortfolios(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.getPortfolios(token);
      _portfolios = data.map((item) => Portfolio.fromJson(item)).toList();
      _calculateTotalValue();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateTotalValue() {
    _totalValue = _portfolios.fold(0, (sum, portfolio) => sum + portfolio.value);
  }

  void updatePerformance(double newPerformance) {
    _overallPerformance = newPerformance;
    notifyListeners();
  }

  List<String> getStockSymbols() {
    // Get unique symbols from the portfolio holdings
    final Set<String> symbols = {};

    // Add symbols from your portfolio data
    // If you're using mock data for now:
    symbols.addAll(['AAPL', 'TSLA', 'MSFT', 'GOOGL', 'NVDA']);

    // If you have actual portfolio data, you would get symbols from there:
    // for (var holding in portfolios) {
    //   symbols.add(holding.symbol);
    // }

    return symbols.toList();
  }
}

class Portfolio {
  final String id;
  final String name;
  final double value;
  final double performance;
  final List<Holding> holdings;

  Portfolio({
    required this.id,
    required this.name,
    required this.value,
    required this.performance,
    required this.holdings,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      performance: (json['performance'] ?? 0).toDouble(),
      holdings: (json['holdings'] as List<dynamic>?)
          ?.map((h) => Holding.fromJson(h))
          .toList() ?? [],
    );
  }
}

class Holding {
  final String symbol;
  final String name;
  final int shares;
  final double currentPrice;
  final double totalValue;
  final double performance;

  Holding({
    required this.symbol,
    required this.name,
    required this.shares,
    required this.currentPrice,
    required this.totalValue,
    required this.performance,
  });

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      shares: json['shares'] ?? 0,
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      performance: (json['performance'] ?? 0).toDouble(),
    );
  }
}