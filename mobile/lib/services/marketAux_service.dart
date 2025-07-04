import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketauxService {
  static const String _baseUrl = 'https://api.marketaux.com/v1';
  static const String _apiKey = 'YOUR_MARKETAUX_API_KEY'; // Replace with your API key

  // For Market News (Dashboard)
  static Future<List<NewsArticle>> getMarketNews() async {
    return _fetchNews('/news/all', {
      'filter_entities': 'true',
      'limit': '10',
      'published_after': _getYesterdayDate(),
    });
  }

  // For Stock-specific News
  static Future<List<NewsArticle>> getStockNews(String symbol) async {
    return _fetchNews('/news/all', {
      'symbols': symbol,
      'filter_entities': 'true',
      'limit': '10',
      'published_after': _getLastWeekDate(),
    });
  }

  // For General Financial News
  static Future<List<NewsArticle>> getGeneralNews() async {
    return _fetchNews('/news/all', {
      'industries': 'Technology,Financial Services',
      'filter_entities': 'true',
      'limit': '10',
      'published_after': _getLastWeekDate(),
    });
  }

  static String _getYesterdayDate() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.toIso8601String();
  }

  static String _getLastWeekDate() {
    final lastWeek = DateTime.now().subtract(const Duration(days: 7));
    return lastWeek.toIso8601String();
  }

  static Future<List<NewsArticle>> _fetchNews(String endpoint, Map<String, String> queryParams) async {
    try {
      final params = {
        ...queryParams,
        'api_token': _apiKey,
        'language': 'en',
      };

      final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: params);

      print('Fetching news from: $uri'); // For debugging

      final response = await http.get(uri);

      print('Response status: ${response.statusCode}'); // For debugging
      print('Response body: ${response.body}'); // For debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> articles = jsonData['data'];

        return articles.map((article) {
          return NewsArticle(
            title: article['title'] ?? '',
            description: article['description'] ?? '',
            publishedDate: DateTime.parse(article['published_at']),
            imageUrl: article['image_url'] ?? '',
            link: article['url'] ?? '',
            source: article['source'] ?? '',
            sentiment: article['sentiment'] ?? 'neutral',
          );
        }).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      print('Error fetching news: $e'); // For debugging
      throw Exception('Failed to fetch news: $e');
    }
  }
}

class NewsArticle {
  final String title;
  final String description;
  final DateTime publishedDate;
  final String imageUrl;
  final String link;
  final String source;
  final String sentiment;

  NewsArticle({
    required this.title,
    required this.description,
    required this.publishedDate,
    required this.imageUrl,
    required this.link,
    required this.source,
    required this.sentiment,
  });
}