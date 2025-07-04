import 'package:flutter/material.dart';
import 'package:stock_market_app/screens/dashboard_screen.dart';
import 'package:stock_market_app/screens/portfolio_screen.dart';
import 'package:stock_market_app/screens/stocks_screen.dart';
import 'package:stock_market_app/screens/pro_version_screen.dart';
import 'package:stock_market_app/screens/news_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PortfolioScreen(),
    const StocksScreen(),
    const ProVersionScreen(),
    const NewsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Define your custom styles
    final labelTextStyle = MaterialStateProperty.resolveWith<TextStyle>(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          );
        }
        return const TextStyle(
          color: Color(0xFF93C6AA),
          fontSize: 12,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
        );
      },
    );

    final iconTheme = MaterialStateProperty.resolveWith<IconThemeData>(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: Colors.white);
        }
        return const IconThemeData(color: Color(0xFF93C6AA));
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFF12211A),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF193326), // Use preferred color
          labelTextStyle: labelTextStyle,
          iconTheme: iconTheme,
          indicatorColor: const Color(0xFF234733),
          height: 64,
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.pie_chart_outline_outlined),
              selectedIcon: Icon(Icons.pie_chart),
              label: 'Portfolio',
            ),
            NavigationDestination(
              icon: Icon(Icons.trending_up_outlined),
              selectedIcon: Icon(Icons.trending_up),
              label: 'Stocks',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_outline),
              selectedIcon: Icon(Icons.star),
              label: 'Pro',
            ),
            NavigationDestination(
              icon: Icon(Icons.article_outlined),
              selectedIcon: Icon(Icons.article),
              label: 'News',
            ),
          ],
        ),
      ),
    );
  }
}
