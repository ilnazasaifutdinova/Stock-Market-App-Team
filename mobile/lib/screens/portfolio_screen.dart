import 'package:flutter/material.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Background gradient circles
          Positioned(
            right: -50,
            top: 146,
            child: Container(
              width: 394,
              height: 394,
              decoration: const BoxDecoration(
                color: Color(0xFFEF42B5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -52,
            bottom: 200,
            child: Container(
              width: 366,
              height: 366,
              decoration: const BoxDecoration(
                color: Color(0xFF0AD842),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Portfolio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Portfolio Performance Section
                  const Text(
                    'Portfolio Performance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '+12.5%',
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
                        '1Y',
                        style: TextStyle(
                          color: Color(0xFF93C6AA),
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '+12.5%',
                        style: TextStyle(
                          color: Color(0xFF0AD842),
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
                        Icons.show_chart,
                        color: Color(0xFF0AD842),
                        size: 100,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Portfolio Distribution
                  const Text(
                    'Portfolio Distribution',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$12,345',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Total Value',
                    style: TextStyle(
                      color: Color(0xFF93C693),
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Distribution Chart placeholder
                  Container(
                    width: double.infinity,
                    height: 180,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDistributionBar('Stocks', const Color(0xFF93C693), 137),
                        _buildDistributionBar('Bonds', const Color(0xFF93C6AA), 137),
                        _buildDistributionBar('Crypto', const Color(0xFF234723), 137),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Holdings List
                  _buildHoldingItem('AAPL', '100 Shares', '\$1,500'),
                  _buildHoldingItem('MSFT', '50 Shares', '\$1,200'),
                  _buildHoldingItem('TSLA', '20 Shares', '\$800'),
                  _buildHoldingItem('AMZN', '150 Shares', '\$2,000'),
                  _buildHoldingItem('GOOG', '75 Shares', '\$1,800'),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionBar(String label, Color color, double height) {
    return Column(
      children: [
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: const Color(0xFF757575), width: 2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF93C693),
            fontSize: 13,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildHoldingItem(String symbol, String shares, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF112111),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                symbol,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                shares,
                style: const TextStyle(
                  color: Color(0xFF93C693),
                  fontSize: 14,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
