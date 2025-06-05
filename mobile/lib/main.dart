import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Импорт экранов (путь ‘screens/…’, без опечаток)
import 'package:stock_market_app/screens/login_screen.dart';
import 'package:stock_market_app/screens/home_screen.dart';
import 'package:stock_market_app/screens/news_screen.dart';
import 'package:stock_market_app/screens/detail_screen.dart';
import 'package:stock_market_app/screens/portfolio_screen.dart';
import 'package:stock_market_app/screens/buy_pro_screen.dart';

// Импорт AuthProvider (убедитесь, что файл существует)
import 'package:stock_market_app/providers/auth_provider.dart';
import 'package:stock_market_app/screens/register_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Market App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? HomeScreen() : LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/news': (context) => NewsScreen(),
        '/detail': (context) => DetailScreen(),
        '/portfolio': (context) => PortfolioScreen(),
        '/buyPro': (context) => BuyProScreen(),
      },
    );
  }
}
