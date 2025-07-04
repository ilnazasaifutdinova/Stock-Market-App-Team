import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class MarketauxService {
  static const String _baseUrl = 'https://api.marketaux.com/v1';
  static const String _apiKey = 'E1CkaLgZrSmBttqceEqoCs3FA5eqykOtFeBfdXcP'; // MarketAux API key

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
    return '${yesterday.year}-${_padTwoDigits(yesterday.month)}-${_padTwoDigits(yesterday.day)}';
  }

  static String _getLastWeekDate() {
    final lastWeek = DateTime.now().subtract(const Duration(days: 7));
    return '${lastWeek.year}-${_padTwoDigits(lastWeek.month)}-${_padTwoDigits(lastWeek.day)}';
  }

  static String _padTwoDigits(int n) {
    return n.toString().padLeft(2, '0');
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

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

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

class DashboardMarketauxService {
  static const String _baseUrl = 'https://api.marketaux.com/v1';
  static const String _apiKey = 'rOHWPqAP3DXzfCdnfcXQ1upYhVL07usSqGQAEy9c'; // Second API key for dashboard

  static Future<List<NewsArticle>> getDashboardNews() async {
    return _fetchNews('/news/all', {
      'filter_entities': 'true',
      'limit': '2',
      'sectors': 'Technology,Financial',
      'published_after': _getYesterdayDate(),
    });
  }

  static String _getYesterdayDate() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${_padTwoDigits(yesterday.month)}-${_padTwoDigits(yesterday.day)}';
  }

  static String _padTwoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  static Future<List<NewsArticle>> _fetchNews(String endpoint, Map<String, String> queryParams) async {
    try {
      final params = {
        ...queryParams,
        'api_token': _apiKey,
        'language': 'en',
      };

      final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: params);
      print('Dashboard Service - Fetching news from: $uri'); // Debug print

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      print('Dashboard Service - Response status: ${response.statusCode}'); // Debug print
      print('Dashboard Service - Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> articles = jsonData['data'];
        print('Dashboard Service - Number of articles: ${articles.length}'); // Debug print

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
      print('Dashboard Service - Error: $e'); // Debug print
      throw Exception('Failed to fetch news: $e');
    }
  }
}
