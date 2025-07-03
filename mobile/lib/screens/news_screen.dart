import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

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
                      'News',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Search Bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF234723),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(
                            Icons.search,
                            color: Color(0xFF93C693),
                            size: 24,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: Color(0xFF93C693),
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Featured News
                  _buildFeaturedNews(
                    'Tech Stocks Surge Amidst New Product Launches',
                    'The tech sector is experiencing a significant boost as several major companies unveil innovative products, driving investor optimism.',
                  ),
                  const SizedBox(height: 16),
                  // Stock Ticker
                  _buildStockTicker('AAPL', '\$175.20', '+1.25%'),
                  const SizedBox(height: 16),
                  // News Articles
                  _buildNewsArticle(
                    'Energy Sector Faces Challenges with Oil Price Fluctuations',
                    'The energy market is grappling with volatility due to fluctuating oil prices, impacting stock performance across the sector.',
                  ),
                  const SizedBox(height: 16),
                  _buildStockTicker('MSFT', '\$330.50', '-0.85%'),
                  const SizedBox(height: 16),
                  _buildDetailedNews(
                    'Financial News',
                    'Tech Innovators Reports Record Quarterly Earnings',
                    'The company\'s Q2 earnings exceeded expectations, driven by strong sales in its cloud computing division.',
                  ),
                  const SizedBox(height: 16),
                  _buildStockTicker('TSLA', '\$700.00', '-1.50%'),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedNews(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
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
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 130,
            height: 149,
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

  Widget _buildStockTicker(String symbol, String price, String change) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF112111),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF234733),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    symbol,
                    style: const TextStyle(
                      color: Color(0xFF93C693),
                      fontSize: 14,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            change,
            style: TextStyle(
              color: change.startsWith('+') ? const Color(0xFF0AD842) : Colors.redAccent,
              fontSize: 16,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsArticle(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
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
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 130,
            height: 148,
            decoration: BoxDecoration(
              color: const Color(0xFF234733),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.energy_savings_leaf,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedNews(String category, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                    height: 1.25,
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
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 130,
            height: 153,
            decoration: BoxDecoration(
              color: const Color(0xFF234733),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.business,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
