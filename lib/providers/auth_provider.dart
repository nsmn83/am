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

  Future<bool> updateUserProfile({
  required String image,
  required String bio,
}) async {
  try {
    final response = await _authService.updateUserProfile(
      bio:  bio,
      image: image,
    );

    // Zakładam, że backend zwraca zaktualizowane dane usera
    _user = User.fromJson(response);
    notifyListeners();

    return true;
  } catch (e) {
    print('Failed to update user profile: $e');
    return false;
  }
}



  /// Logowanie
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);

    _isLoading = false;
    
    if (result != null) {
      _user = result['user'] as User; // Store the user
      notifyListeners();
      return true;
    }
    
    notifyListeners();
    return false;
  }

  /// Rejestracja
  Future<bool> register(String username, String email, String password1, String password2) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(username, email, password1, password2);

    _isLoading = false;
    
    if (result != null) {
      _user = result['user'] as User; // Store the user
      notifyListeners();
      return true;
    }
    
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null; // Clear the user
    notifyListeners();
  }

  Dio get dio => _authService.dio;
}