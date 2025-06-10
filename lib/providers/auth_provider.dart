import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? get token => _authService.token;

  bool get isAuthenticated => token != null;

  /// Inicjalizuj token przy starcie aplikacji
  Future<void> loadToken() async {
    await _authService.loadToken();
    notifyListeners();
  }

  /// Logowanie
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.login(email, password);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  /// Rejestracja
  Future<bool> register(String username, String email, String password1, String password2) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.register(username, email, password1, password2);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  /// Wylogowanie
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  Dio get dio => _authService.dio;
}
