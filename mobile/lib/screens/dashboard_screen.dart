import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market_app/providers/news_provider.dart';
import 'package:stock_market_app/providers/portfolio_provider.dart';
import 'package:stock_market_app/providers/market_data_provider.dart';
import 'package:stock_market_app/providers/auth_provider.dart';
import 'package:stock_market_app/widgets/animated_gradient_background.dart';
import 'package:stock_market_app/widgets/stock_chart_widget.dart';
import 'package:stock_market_app/models/stock_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadData();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final marketProvider = Provider.of<MarketDataProvider>(context, listen: false);

      if (authProvider.token != null) {
        final stocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'META', 'NVDA', 'TSLA'];
        for (var symbol in stocks) {
          marketProvider.fetchStockData(symbol, '1D');
        }
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      child: SafeArea(
        child: Consumer4<PortfolioProvider, MarketDataProvider, AuthProvider, NewsProvider>(
          builder: (context, portfolioProvider, marketProvider, authProvider, NewsProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildHeader(authProvider),
                  ),

                  const SizedBox(height: 40),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildPortfolioOverview(portfolioProvider),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildMarketOverview(marketProvider),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildTopStocksSection(marketProvider),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildRecentNewsSection(),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(AuthProvider authProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning',
              style: TextStyle(
                color: Color(0xFF93C6AA),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Welcome back!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF234733),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioOverview(PortfolioProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF193326),
            const Color(0xFF234733).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0AD842).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0AD842).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Portfolio Value',
                style: TextStyle(
                  color: Color(0xFF93C6AA),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0AD842).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${provider.overallPerformance.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Color(0xFF0AD842),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 2000),
            tween: Tween(begin: 0, end: provider.totalValue),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Text(
                '\$${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _buildQuickStat('Today\'s Change', '+\$127.45', true),
              const SizedBox(width: 24),
              _buildQuickStat('This Week', '+\$892.12', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF93C6AA),
            fontSize: 12,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isPositive ? const Color(0xFF0AD842) : Colors.red,
            fontSize: 14,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMarketOverview(MarketDataProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Market Overview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        Container(
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFF193326),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF234733),
              width: 1,
            ),
          ),
          child: StockChartWidget(
            data: provider.chartData,
            height: 200,
            lineColor: const Color(0xFF0AD842),
            gradientStartColor: const Color(0xFF0AD842).withOpacity(0.2),
            gradientEndColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget _buildTopStocksSection(MarketDataProvider provider) {
    final topStocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'META', 'NVDA', 'TSLA'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Top Stocks',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to stocks screen
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF0AD842),
                  fontSize: 14,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topStocks.length,
          itemBuilder: (context, index) {
            final symbol = topStocks[index];
            final stockData = provider.getStockData(symbol);

            if (stockData == null) {
              provider.fetchStockData(symbol, '1D');
              return const SizedBox.shrink();
            }

            return _buildStockItem(symbol, stockData);
          },
        ),
      ],
    );
  }

  Widget _buildStockItem(String symbol, StockData stockData) {
    final isPositive = stockData.changePercent >= 0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF193326),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF234733),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF234733),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                symbol,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCompanyName(symbol),
                  style: const TextStyle(
                    color: Color(0xFF93C6AA),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${stockData.currentPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? const Color(0xFF0AD842) : Colors.red,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${stockData.changePercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isPositive ? const Color(0xFF0AD842) : Colors.red,
                      fontSize: 14,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCompanyName(String symbol) {
    final Map<String, String> companies = {
      'AAPL': 'Apple Inc.',
      'GOOGL': 'Alphabet Inc.',
      'MSFT': 'Microsoft Corp.',
      'AMZN': 'Amazon.com Inc.',
      'META': 'Meta Platforms Inc.',
      'NVDA': 'NVIDIA Corp.',
      'TSLA': 'Tesla Inc.',
    };
    return companies[symbol] ?? 'Unknown Company';
  }

  Widget _buildRecentNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Market News',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to news screen
              },
              child: const Text(
                'More',
                style: TextStyle(
                  color: Color(0xFF0AD842),
                  fontSize: 14,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildNewsItem(
          'Tech Stocks Rally as AI Sector Shows Strong Growth',
          'Markets saw significant gains today as artificial intelligence companies reported better than expected earnings.',
          '2h ago',
        ),

        _buildNewsItem(
          'Federal Reserve Signals Potential Rate Changes',
          'Economic indicators suggest possible monetary policy adjustments in the coming quarter.',
          '4h ago',
        ),
      ],
    );
  }

  Widget _buildNewsItem(String title, String description, String time) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF193326),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF234733),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF93C6AA),
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF93C6AA),
              fontSize: 10,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}