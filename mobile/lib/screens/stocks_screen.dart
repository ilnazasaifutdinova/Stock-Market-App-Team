import 'package:flutter/material.dart';
import 'package:stock_market_app/widgets/animated_gradient_background.dart';

class StocksScreen extends StatelessWidget {
  const StocksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Stocks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Company Header
              const Text(
                'Tech Innovators Inc. (TII)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 24),

              // Time Period Selector
              Container(
                height: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF234723),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _buildTimeButton('1D', false),
                    _buildTimeButton('1M', true),
                    _buildTimeButton('3M', false),
                    _buildTimeButton('1Y', false),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Stock Price Section
              const Text(
                'TII Stock Price',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '\$150.25',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Last Month',
                    style: TextStyle(
                      color: Color(0xFF93C693),
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '+5.2%',
                    style: TextStyle(
                      color: Color(0xFF0AD838),
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Chart placeholder
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF193326),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.candlestick_chart,
                    color: Color(0xFF0AD842),
                    size: 100,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Stock Details
              Row(
                children: [
                  Expanded(
                    child: _buildStockDetail('Open', '\$145.00'),
                  ),
                  Expanded(
                    child: _buildStockDetail('Close', '\$150.25'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildStockDetail('High', '\$152.50'),
                  ),
                  Expanded(
                    child: _buildStockDetail('Low', '\$144.75'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Company Description
              const Text(
                'Tech Innovators Inc. is a leading technology company specializing in AI and cloud computing solutions. The company\'s stock has shown steady growth over the past year, driven by strong financial performance and positive market sentiment.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),

              const SizedBox(height: 32),

              // News Section
              const Text(
                'News',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              _buildNewsCard(
                'Market Insights',
                'Tech Innovators Announces New AI Partnership',
                'The company partners with a major healthcare provider to develop AI-driven diagnostic tools.',
              ),

              const SizedBox(height: 16),

              _buildNewsCard(
                'Financial News',
                'Tech Innovators Reports Record Quarterly Earnings',
                'The company\'s Q2 earnings exceeded expectations, driven by strong sales in its cloud computing division.',
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton(String label, bool isSelected) {
    return Expanded(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF112111) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF93C693),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockDetail(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E8EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF93C693),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String category, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Color(0xFF93C693),
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF93C693),
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFF234733),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.article,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
