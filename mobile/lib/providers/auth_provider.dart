import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> restoreSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _authService.getStoredToken();
      if (token != null) {
        _apiService.setAuthToken(token);
        _isAuthenticated = true;
        _error = null;
        return true;
      }
    } catch (e) {
      _error = e.toString();
      _user = null;
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response['access_token'] != null) {
        await _authService.saveToken(response['access_token']);
        _apiService.setAuthToken(response['access_token']);
        _user = User.fromJson(response['user'] ?? {});
        _isAuthenticated = true;
        return true;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String email, String password, String? name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/register', {
        'email': email,
        'password': password,
        'name': name,
      });

      if (response['access_token'] != null) {
        await _authService.saveToken(response['access_token']);
        _apiService.setAuthToken(response['access_token']);
        _user = User.fromJson(response['user'] ?? {});
        _isAuthenticated = true;
        return true;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.post('/auth/logout', {});
      await _authService.clearToken();
      _user = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
