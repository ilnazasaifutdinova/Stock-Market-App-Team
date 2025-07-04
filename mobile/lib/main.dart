import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_app/providers/auth_provider.dart';
import 'package:stock_market_app/providers/news_provider.dart';
import 'package:stock_market_app/providers/portfolio_provider.dart';
import 'package:stock_market_app/providers/market_data_provider.dart';
import 'package:stock_market_app/screens/splash_screen.dart';
import 'package:stock_market_app/screens/stock_test_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => MarketDataProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockVision',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: const Color(0xFF12211A),
      ),
      home: const SplashScreen(),
      //home: const StockTestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}