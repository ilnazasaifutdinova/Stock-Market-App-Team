import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../providers/market_data_provider.dart';

class StockTestScreen extends StatefulWidget {
  const StockTestScreen({Key? key}) : super(key: key);

  @override
  _StockTestScreenState createState() => _StockTestScreenState();
}

class _StockTestScreenState extends State<StockTestScreen> {
  final List<String> watchlist = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'META'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch multiple stocks
      for (String symbol in watchlist) {
        context.read<MarketDataProvider>().fetchStockData(symbol, '1D');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Market')),
      body: Consumer<MarketDataProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              final symbol = watchlist[index];
              final stockData = provider.getStockData(symbol);
              final isLoading = provider.isSymbolLoading(symbol);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(symbol),
                  subtitle: isLoading
                      ? const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Loading...'),
                    ],
                  )
                      : stockData == null
                      ? const Text('Failed to load data')
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${stockData.currentPrice.toStringAsFixed(2)}'),
                      Text(
                        '${stockData.change >= 0 ? '+' : ''}${stockData.changePercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: stockData.change >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}