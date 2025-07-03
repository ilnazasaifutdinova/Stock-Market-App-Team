import 'package:flutter/material.dart';
import 'package:stock_market_app/services/api_service.dart';
import 'package:stock_market_app/models/portfolio.dart';
import 'package:flutter/foundation.dart';
import 'package:stock_market_app/services/finnhub_service.dart';
import 'package:stock_market_app/models/stock_data.dart';

class PortfolioProvider extends ChangeNotifier {
  List<Portfolio> _portfolios = [];
  double _totalValue = 12345.67;
  double _overallPerformance = 8.5;
  bool _isLoading = false;
  String? _error;

  List<Portfolio> get portfolios => _portfolios;
  double get totalValue => _totalValue;
  double get overallPerformance => _overallPerformance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> getStockSymbols() {
    Set<String> symbols = {};
    for (var portfolio in _portfolios) {
      for (var holding in portfolio.holdings) {
        symbols.add(holding.symbol);
      }
    }
    return symbols.toList();
  }

  Future<void> updatePortfolioValue(Map<String, StockData> stocksData) async {
    double newTotalValue = 0.0;
    double previousValue = _totalValue;

    for (var portfolio in _portfolios) {
      portfolio.updateValue(stocksData);
      newTotalValue += portfolio.value;
    }

    _totalValue = newTotalValue;

    if (previousValue > 0) {
      _overallPerformance = ((newTotalValue - previousValue) / previousValue) * 100;
    }

    notifyListeners();
  }

  Future<void> fetchPortfolios(String token) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Initialize with empty portfolios first
      _portfolios = [];
      _totalValue = 0.0;
      _overallPerformance = 0.0;

      // Add mock portfolios
      _portfolios = [
        Portfolio(
          id: '1',
          name: 'Growth Portfolio',
          holdings: [
            Holding(
              symbol: 'AAPL',
              shares: 10,
              name: 'Apple Inc.',
            ),
            Holding(
              symbol: 'MSFT',
              shares: 15,
              name: 'Microsoft Corporation',
            ),
          ],
        ),
        Portfolio(
          id: '2',
          name: 'Tech Portfolio',
          holdings: [
            Holding(
              symbol: 'GOOGL',
              shares: 5,
              name: 'Alphabet Inc.',
            ),
            Holding(
              symbol: 'NVDA',
              shares: 8,
              name: 'NVIDIA Corporation',
            ),
          ],
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _portfolios = [];
      notifyListeners();
      throw Exception('Failed to fetch portfolios: ${e.toString()}');
    }
  }

  void updatePerformance(double newPerformance) {
    _overallPerformance = newPerformance;
    notifyListeners();
  }
}

class Portfolio {
  final String id;
  final String name;
  final List<Holding> holdings;
  double value = 0.0;
  double performance = 0.0;

  Portfolio({
    required this.id,
    required this.name,
    required this.holdings,
  });

  void updateValue(Map<String, StockData> stocksData) {
    double newValue = 0.0;
    double previousValue = value;

    for (var holding in holdings) {
      holding.updateValue(stocksData[holding.symbol]);
      newValue += holding.totalValue;
    }

    value = newValue;
    if (previousValue > 0) {
      performance = ((newValue - previousValue) / previousValue) * 100;
    }
  }
}

class Holding {
  final String symbol;
  final String name;
  final int shares;
  double currentPrice = 0.0;
  double totalValue = 0.0;
  double performance = 0.0;

  Holding({
    required this.symbol,
    required this.shares,
    required this.name,
  });

  void updateValue(StockData? stockData) {
    if (stockData != null) {
      currentPrice = stockData.currentPrice;
      totalValue = currentPrice * shares;
      performance = stockData.changePercent;
    }
  }
}

