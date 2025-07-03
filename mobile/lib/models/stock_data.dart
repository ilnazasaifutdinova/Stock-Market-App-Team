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

  factory StockData.fromFinnhubJson(Map<String, dynamic> json, String symbol) {
    return StockData(
      symbol: symbol,
      currentPrice: (json['c'] ?? 0).toDouble(),  // Current price
      change: (json['d'] ?? 0).toDouble(),        // Change
      changePercent: (json['dp'] ?? 0).toDouble(), // Percent change
      high: (json['h'] ?? 0).toDouble(),          // High price of the day
      low: (json['l'] ?? 0).toDouble(),           // Low price of the day
      open: (json['o'] ?? 0).toDouble(),          // Open price of the day
      volume: (json['v'] ?? 0).toInt(),           // Volume
    );
  }
}