// mobile/lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final stored = await _storage.read(key: 'jwtToken');
    if (stored != null) {
      _token = stored;
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final result = await ApiService.login(email, password);
      _token = result;
      await _storage.write(key: 'jwtToken', value: _token);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    return await ApiService.register(email, password);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwtToken');
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
