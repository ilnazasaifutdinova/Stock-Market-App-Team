// mobile/lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/news_screen.dart';
import 'package:mobile/screens/detail_screen.dart';
import 'package:mobile/screens/portfolio_screen.dart';
import 'package:mobile/screens/buy_pro_screen.dart';

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
      // Если пользователь уже залогинен, сразу показываем Home, иначе — Login
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? HomeScreen() : LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/news': (context) => NewsScreen(),
        '/detail': (context) => DetailScreen(),      // ожидание аргумента через ModalRoute
        '/portfolio': (context) => PortfolioScreen(),
        '/buyPro': (context) => BuyProScreen(),
      },
    );
  }
}
