// lib/models/portfolio.dart
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