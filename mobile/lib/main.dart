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

// Main content
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 60),
                  child: const Text(
                    'StockVision',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      height: 1.28,
                    ),
                  ),
                ),
                
                const Spacer(flex: 1),
                
                Container(
                  width: 300,
                  height: 300,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.trending_up,
                      size: 120,
                      color: Color(0xFF14B75B),
                    ),
                  ),
                ),
                
                const Spacer(flex: 1),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome to StockVision',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your personal finance assistant',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B75B),
                            foregroundColor: const Color(0xFF112119),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

