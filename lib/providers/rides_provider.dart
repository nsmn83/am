import 'package:flutter/material.dart';
import '../services/rides_service.dart';

class RidesProvider with ChangeNotifier {
  final RidesService _ridesService;

  String _message = '';
  bool _isLoading = false;
  String? _error;

  String get message => _message;
  bool get isLoading => _isLoading;
  String? get error => _error;

  RidesProvider(this._ridesService);

  Future<void> fetchRidesMessage() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _message = await _ridesService.fetchRidesMessage();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Możesz dodać więcej metod, np.:
  // Future<void> fetchRides() async { ... }
  // Future<void> createRide(Ride ride) async { ... }
}