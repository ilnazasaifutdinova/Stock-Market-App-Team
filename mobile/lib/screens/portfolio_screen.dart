import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_market_app/providers/market_data_provider.dart';
import 'package:stock_market_app/providers/portfolio_provider.dart';
import 'package:stock_market_app/providers/auth_provider.dart';
import 'package:stock_market_app/services/finnhub_service.dart';
import 'package:stock_market_app/widgets/animated_gradient_background.dart';
import 'package:stock_market_app/widgets/stock_chart_widget.dart';
import 'package:stock_market_app/models/chart_data_point.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _chartAnimationController;
  late AnimationController _pieAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pieAnimation;

  int selectedChartIndex = -1;
  String selectedTimeframe = '1Y';
  final List<String> timeframes = ['1W', '1M', '3M', '6M', '1Y'];
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    // Call fetchStockData here instead of didChangeDependencies
    final authProvider = context.read<AuthProvider>();
    final portfolioProvider = context.read<PortfolioProvider>();
    final marketDataProvider = context.read<MarketDataProvider>();

    if (authProvider.token != null) {
      _loadPortfolioData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      _loadPortfolioData();
      _isDataLoaded = true;
    }
  }

  void _loadPortfolioData() async {
    final authProvider = context.read<AuthProvider>();
    final portfolioProvider = context.read<PortfolioProvider>();
    final marketDataProvider = context.read<MarketDataProvider>();

    try {
      await portfolioProvider.fetchPortfolios(authProvider.token!);
      // Fetch data for all symbols in parallel
      final symbols = portfolioProvider.getStockSymbols();
      await Future.wait(
          symbols.map((symbol) =>
              marketDataProvider.fetchStockData(symbol, selectedTimeframe)
          )
      );
      // Update portfolio value with real stock data
      await portfolioProvider.updatePortfolioValue(marketDataProvider.stocksData);
    } catch (e) {
      if (mounted) {  // Check if widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading portfolio: $e'))
        );
      }
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _chartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _pieAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _chartAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _pieAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pieAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
    _chartAnimationController.forward();
    _pieAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chartAnimationController.dispose();
    _pieAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      child: SafeArea(
        child: Consumer3<PortfolioProvider, AuthProvider, MarketDataProvider>(
          builder: (context, portfolioProvider, authProvider, marketDataProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildHeader(),
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildPerformanceOverview(portfolioProvider),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildTimeframeSelector(),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildPerformanceChart(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _pieAnimation,
                      child: _buildPortfolioDistribution(portfolioProvider),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildPortfolioMetrics(portfolioProvider),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildHoldingsList(portfolioProvider),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildRecentTransactions(),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Portfolio',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF234733),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.tune,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceOverview(PortfolioProvider provider) {
    return Container(
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
                'Total Portfolio Value',
                style: TextStyle(
                  color: Color(0xFF93C6AA),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0AD842).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Color(0xFF0AD842),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${provider.overallPerformance.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Color(0xFF0AD842),
                        fontSize: 14,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 2500),
            tween: Tween(begin: 0, end: provider.totalValue),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Text(
                '\$${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildQuickStat('1Y', '+12.5%', '+\$1,427')),
              Container(width: 1, height: 40, color: const Color(0xFF234733)),
              Expanded(child: _buildQuickStat('1M', '+3.2%', '+\$387')),
              Container(width: 1, height: 40, color: const Color(0xFF234733)),
              Expanded(child: _buildQuickStat('1W', '+1.1%', '+\$127')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String period, String percent, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            period,
            style: const TextStyle(
              color: Color(0xFF93C6AA),
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            percent,
            style: const TextStyle(
              color: Color(0xFF0AD842),
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
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

  Widget _buildTimeframeSelector() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF234733),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: timeframes.map((timeframe) {
          final isSelected = timeframe == selectedTimeframe;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTimeframe = timeframe;
                });
                // For market data fetching
                final marketDataProvider = context.read<MarketDataProvider>();
                final portfolioProvider = context.read<PortfolioProvider>();
                for (var symbol in portfolioProvider.getStockSymbols()) {
                  marketDataProvider.fetchHistoricalData(symbol, timeframe);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF193326)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected
                      ? [
                    const BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    timeframe,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF93C6AA),
                      fontSize: 14,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Portfolio Performance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              selectedTimeframe,
              style: const TextStyle(
                color: Color(0xFF93C6AA),
                fontSize: 14,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<MarketDataProvider>(
          builder: (context, marketDataProvider, child) {
            if (marketDataProvider.isLoading) {
              return Container(
                height: 220,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0AD842)),
                ),
              );
            }
            return StockChartWidget(
              data: marketDataProvider.chartData,
              height: 220,
              lineColor: const Color(0xFF0AD842),
              gradientStartColor: const Color(0xFF0AD842),
              gradientEndColor: Colors.transparent,
              showGrid: true,
              showTooltip: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPortfolioDistribution(PortfolioProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Asset Distribution',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '\$${provider.totalValue.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Color(0xFF93C6AA),
                fontSize: 14,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFF193326),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF234733),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AnimatedBuilder(
                      animation: _pieAnimation,
                      builder: (context, child) {
                        return PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event,
                                  pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    selectedChartIndex = -1;
                                    return;
                                  }
                                  selectedChartIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 4,
                            centerSpaceRadius: 35,
                            sections: _buildPieChartSections(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                          'Stocks', 65, 8234.55, const Color(0xFF0AD842), 0),
                      const SizedBox(height: 16),
                      _buildLegendItem(
                          'Bonds', 25, 3157.90, const Color(0xFF93C6AA), 1),
                      const SizedBox(height: 16),
                      _buildLegendItem(
                          'Crypto', 10, 1252.22, const Color(0xFF234733), 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final animationValue = _pieAnimation.value;

    return [
      PieChartSectionData(
        color: const Color(0xFF0AD842),
        value: 65 * animationValue,
        title: selectedChartIndex == 0 ? '65%' : '',
        radius: selectedChartIndex == 0 ? 70 : 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: selectedChartIndex == 0 ? _buildBadge('\$8.2K') : null,
      ),
      PieChartSectionData(
        color: const Color(0xFF93C6AA),
        value: 25 * animationValue,
        title: selectedChartIndex == 1 ? '25%' : '',
        radius: selectedChartIndex == 1 ? 70 : 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: selectedChartIndex == 1 ? _buildBadge('\$3.2K') : null,
      ),
      PieChartSectionData(
        color: const Color(0xFF234733),
        value: 10 * animationValue,
        title: selectedChartIndex == 2 ? '10%' : '',
        radius: selectedChartIndex == 2 ? 70 : 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: selectedChartIndex == 2 ? _buildBadge('\$1.3K') : null,
      ),
    ];
  }

  Widget _buildBadge(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLegendItem(
      String label, int percentage, double value, Color color, int index) {
    final isSelected = selectedChartIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedChartIndex = selectedChartIndex == index ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color:
                      isSelected ? Colors.white : const Color(0xFF93C6AA),
                      fontSize: 12,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF93C6AA),
                          fontSize: 10,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '\$${(value / 1000).toStringAsFixed(1)}K',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF93C6AA),
                          fontSize: 10,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioMetrics(PortfolioProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF193326),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF234733),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio Metrics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetricItem('Beta', '1.23', 'vs Market')),
              Expanded(
                  child: _buildMetricItem('Sharpe Ratio', '1.84', 'Risk Adjusted')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildMetricItem('Max Drawdown', '-8.2%', 'Worst Case')),
              Expanded(
                  child: _buildMetricItem('Volatility', '14.7%', 'Annual')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
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

  Widget _buildHoldingsList(PortfolioProvider provider) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getMockHoldings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0AD842)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading holdings: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final holdings = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Holdings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to detailed holdings view
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
            ...holdings.asMap().entries.map((entry) {
              final index = entry.key;
              final holding = entry.value;
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 500 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutBack,
                builder: (context, animation, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - animation)),
                    child: Opacity(
                      opacity: animation,
                      child: _buildHoldingItem(holding),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildHoldingItem(Map<String, dynamic> holding) {
    final isPositive = holding['performance'] >= 0;

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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF234733),
                  const Color(0xFF0AD842).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                holding['symbol'],
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
                  holding['symbol'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${holding['shares']} shares',
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
                holding['value'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF0AD842).withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${holding['performance'].toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isPositive ? const Color(0xFF0AD842) : Colors.red,
                    fontSize: 10,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = _getMockTransactions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to transaction history
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
        ...transactions.asMap().entries.map((entry) {
          final index = entry.key;
          final transaction = entry.value;
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 500 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, animation, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - animation)),
                child: Opacity(
                  opacity: animation,
                  child: _buildTransactionItem(transaction),
                ),
              );
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isBuy = transaction['type'] == 'BUY';

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isBuy
                  ? const Color(0xFF0AD842).withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isBuy ? Icons.add : Icons.remove,
              color: isBuy ? const Color(0xFF0AD842) : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction['type']} ${transaction['symbol']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction['shares']} shares at ${transaction['price']}',
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
                transaction['total'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction['date'],
                style: const TextStyle(
                  color: Color(0xFF93C6AA),
                  fontSize: 10,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods for mock data
  List<ChartDataPoint> _generatePerformanceData() {
    final List<ChartDataPoint> data = [];
    double baseValue = 10000;
    int days;

    switch (selectedTimeframe) {
      case '1W':
        days = 7;
        break;
      case '1M':
        days = 30;
        break;
      case '3M':
        days = 90;
        break;
      case '6M':
        days = 180;
        break;
      case '1Y':
      default:
        days = 365;
        break;

    }

    for (int i = 0; i < days; i++) {
      double volatility = (i % 7) / 10.0 - 0.35;
      double growthRate = 0.0008;
      baseValue += (baseValue * growthRate) + (baseValue * 0.02 * volatility);

      data.add(ChartDataPoint(
        time: DateTime.now().subtract(Duration(days: days - 1 - i)),
        price: baseValue,
      ));
    }

    return data;
  }

  Future<List<Map<String, dynamic>>> _getMockHoldings() async {
    try {
      final portfolioProvider = context.read<PortfolioProvider>();
      final holdings = <Map<String, dynamic>>[];

      for (var portfolio in portfolioProvider.portfolios) {
        for (var holding in portfolio.holdings) {
          try {
            final quote = await PortfolioFinnhubService.getQuote(holding.symbol);
            holdings.add({
              'symbol': holding.symbol,
              'shares': holding.shares,
              'value': '\$${(quote.currentPrice * holding.shares).toStringAsFixed(2)}',
              'performance': quote.changePercent,
              'currentPrice': quote.currentPrice,
            });
          } catch (e) {
            print('Error fetching data for ${holding.symbol}: $e');
          }
        }
      }

      return holdings;
    } catch (e) {
      print('Error fetching holdings data: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> _getMockTransactions() {
    return [
      {
        'type': 'BUY',
        'symbol': 'NVDA',
        'shares': 5,
        'price': '\$875.20',
        'total': '\$4,376.00',
        'date': '2 days ago',
      },
      {
        'type': 'SELL',
        'symbol': 'META',
        'shares': 10,
        'price': '\$485.30',
        'total': '\$4,853.00',
        'date': '1 week ago',
      },
      {
        'type': 'BUY',
        'symbol': 'AAPL',
        'shares': 15,
        'price': '\$175.45',
        'total': '\$2,631.75',
        'date': '2 weeks ago',
      },
      {
        'type': 'BUY',
        'symbol': 'TSLA',
        'shares': 8,
        'price': '\$247.00',
        'total': '\$1,976.00',
        'date': '3 weeks ago',
      },
    ];
  }
}
