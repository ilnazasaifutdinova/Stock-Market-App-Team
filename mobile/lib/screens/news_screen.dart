import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../services/marketAux_service.dart';
import 'package:stock_market_app/widgets/animated_gradient_background.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<String> watchlist = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'META'];
  String selectedSymbol = 'AAPL';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchStockNews(selectedSymbol);
    });
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'News',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (String symbol) {
                      setState(() {
                        selectedSymbol = symbol;
                        context.read<NewsProvider>().fetchStockNews(symbol);
                      });
                    },
                    child: Chip(
                      label: Text(
                        selectedSymbol,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF234723),
                    ),
                    itemBuilder: (BuildContext context) {
                      return watchlist.map((String symbol) {
                        return PopupMenuItem<String>(
                          value: symbol,
                          child: Text(symbol),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Search Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF234723),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.search,
                        color: Color(0xFF93C693),
                        size: 24,
                      ),
                    ),
                    Expanded(
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
              Consumer<NewsProvider>(
                builder: (context, newsProvider, child) {
                  if (newsProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (newsProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${newsProvider.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<NewsProvider>().fetchStockNews(selectedSymbol);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (newsProvider.stockNews.isEmpty) {
                    return const Center(
                      child: Text('No news available for this stock'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: newsProvider.stockNews.length,
                    itemBuilder: (context, index) {
                      final article = newsProvider.stockNews[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        color: const Color(0xFF193326),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFF234733),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        article.description,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF93C693),
                                          fontSize: 14,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _formatDate(article.publishedDate),
                                        style: const TextStyle(
                                          color: Color(0xFF93C693),
                                          fontSize: 12,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                if (article.imageUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      article.imageUrl,
                                      width: 130,
                                      height: 148,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 130,
                                          height: 148,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF234733),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.article,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
