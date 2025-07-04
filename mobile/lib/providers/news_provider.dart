import 'package:flutter/foundation.dart';
import 'package:stock_market_app/services/marketAux_service.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsArticle> _marketNews = [];
  List<NewsArticle> _stockNews = [];
  List<NewsArticle> _generalNews = [];
  bool _isLoading = false;
  String? _error;

  List<NewsArticle> get marketNews => _marketNews;
  List<NewsArticle> get stockNews => _stockNews;
  List<NewsArticle> get generalNews => _generalNews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMarketNews() async {
    _setLoading(true);
    try {
      _marketNews = await MarketauxService.getMarketNews();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
    notifyListeners();
  }

  Future<void> fetchStockNews(String symbol) async {
    _setLoading(true);
    try {
      _stockNews = await MarketauxService.getStockNews(symbol);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
    notifyListeners();
  }

  Future<List<NewsArticle>> fetchStockNewsForSymbols(List<String> symbols) async {
    _setLoading(true);
    List<NewsArticle> allNews = [];
    try {
      for (String symbol in symbols) {
        final news = await MarketauxService.getStockNews(symbol);
        if (news.isNotEmpty) {
          allNews.add(news.first); // Get the first news item for each symbol
        }
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
    notifyListeners();
    return allNews;
  }

  Future<void> fetchGeneralNews() async {
    _setLoading(true);
    try {
      _generalNews = await MarketauxService.getGeneralNews();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}