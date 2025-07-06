import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stock_market_app/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  String? _token;
  String? _userEmail;
  bool _isLoading = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get userEmail => _userEmail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final stored = await _storage.read(key: 'jwtToken');
      final email = await _storage.read(key: 'userEmail');
      
      if (stored != null) {
        _token = stored;
        _userEmail = email;
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to load authentication data';
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For demo purposes
      if (email == 'demo@stockvision.com' && password == 'demo123') {
        _token = 'demo_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        _userEmail = email;
        await _storage.write(key: 'jwtToken', value: _token);
        await _storage.write(key: 'userEmail', value: email);
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // Try real API call
      final result = await ApiService.login(email, password);
      _token = result;
      _userEmail = email;
      await _storage.write(key: 'jwtToken', value: _token);
      await _storage.write(key: 'userEmail', value: email);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Login failed: Invalid credentials';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String firstName, String lastName, String email, String password, String dateOfBirth) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For demo purposes, simulate successful registration
      await Future.delayed(const Duration(seconds: 1));
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Registration failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'jwtToken');
      await _storage.delete(key: 'userEmail');
      _token = null;
      _userEmail = null;
      _isAuthenticated = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to logout';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}