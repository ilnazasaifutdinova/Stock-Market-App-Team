import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_app/providers/market_data_provider.dart';

class StockTestScreen extends StatefulWidget {
  const StockTestScreen({Key? key}) : super(key: key);

  @override
  _StockTestScreenState createState() => _StockTestScreenState();
}

class _StockTestScreenState extends State<StockTestScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketDataProvider>().fetchStockData('AAPL', '1D');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Test'),
      ),
      body: Consumer<MarketDataProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                'Error: ${provider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final stockData = provider.getStockData('AAPL');
          if (stockData == null) {
            return const Center(child: Text('No data available'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Symbol: ${stockData.symbol}'),
                Text('Price: \$${stockData.currentPrice}'),
                Text('Change: ${stockData.change}'),
                Text('Change %: ${stockData.changePercent}%'),
              ],
            ),
          );
        },
      ),
    );
  }
}