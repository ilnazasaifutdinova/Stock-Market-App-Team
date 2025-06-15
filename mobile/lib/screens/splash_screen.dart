import 'package:flutter/material.dart';

void main() {
  runApp(const StockVisionApp());
}

class StockVisionApp extends StatelessWidget {
  const StockVisionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockVision',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Manrope',
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12211A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background gradient circles
            Positioned(
              left: -39,
              top: -63,
              child: Container(
                width: 335,
                height: 335,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF42B5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -100,
              top: 139,
              child: Container(
                width: 268,
                height: 268,
                decoration: const BoxDecoration(
                  color: Color(0xFF0AD842),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -150,
              bottom: -200,
              child: Container(
                width: 335,
                height: 335,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF42B5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -50,
              bottom: 50,
              child: Container(
                width: 268,
                height: 268,
                decoration: const BoxDecoration(
                  color: Color(0xFF0AD842),
                  shape: BoxShape.circle,
                ),
              ),
            ),
