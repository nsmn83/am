import 'package:am_project/providers/rides_provider.dart';
import 'package:am_project/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    _user = User.fromJson(response);
    notifyListeners();

    return true;
  } catch (e) {
    print('Failed to update user profile: $e');
    return false;
  }
}



  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);

    _isLoading = false;
    
    if (result != null) {
      _user = result['user'] as User;
      notifyListeners();
      return true;
    }
    
    notifyListeners();
    return false;
  }

  Future<bool> register(String username, String email, String password1, String password2) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(username, email, password1, password2);

    _isLoading = false;
    
    if (result != null) {
      _user = result['user'] as User;
      notifyListeners();
      return true;
    }
    
    notifyListeners();
    return false;
  }

Future<void> logout(BuildContext context) async {
  try {
    await _authService.logout();
  } catch (e) {
    print('Logout failed: $e');
  }

  _user = null;
  notifyListeners();

  final ridesProvider = Provider.of<RidesProvider>(context, listen: false);
  ridesProvider.reset();

  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  themeProvider.reset();
}

  Dio get dio => _authService.dio;
}