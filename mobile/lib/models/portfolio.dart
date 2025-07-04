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

class ChartDataPoint {
  final DateTime time;
  final double price;

  ChartDataPoint({required this.time, required this.price});
}