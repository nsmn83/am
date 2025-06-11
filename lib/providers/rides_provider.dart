import 'package:flutter/foundation.dart';
import '../services/rides_service.dart';
import '../models/ride.dart';

class RidesProvider with ChangeNotifier {
  final RidesService _ridesService;

  RidesProvider(this._ridesService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<Ride> _rides = [];
  List<Ride> get rides => _rides;

  List<Ride> _myRides = [];
  List<Ride> get myRides => _myRides;

  Ride? _currentRide;
  Ride? get currentRide => _currentRide;

  Future<void> fetchMyRides() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myRides = await _ridesService.fetchMyRides();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addRide(Map<String, dynamic> rideData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _ridesService.createRide(rideData);
      await fetchRides(); // Odśwież listę tylko przy sukcesie
      return true;
    } catch (e) {
      // Nie ustawiamy errora globalnie
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRides({
    String? startAddress,
    String? endAddress,
    String? date,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rides = await _ridesService.fetchRides(
        startAddress: startAddress,
        endAddress: endAddress,
        date: date,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRideById(int rideId) async {_isLoading = true; _error = null; _currentRide = null; 
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentRide = await _ridesService.fetchRideById(rideId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


Future<bool> acceptPassengerRequest(int requestId, int rideId) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    await _ridesService.acceptPassengerRequest(requestId);
    await fetchMyRides();
    await fetchRides();

    if (_currentRide != null && _currentRide!.id == rideId) {
      await fetchRideById(rideId);
    }

    return true;
  } catch (e) {
    _error = e.toString();
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<bool> rejectPassengerRequest(int requestId, int rideId) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    await _ridesService.rejectPassengerRequest(requestId);
    await fetchMyRides();
    await fetchRides();

    if (_currentRide != null && _currentRide!.id == rideId) {
      await fetchRideById(rideId);
    }

    return true;
  } catch (e) {
    _error = e.toString();
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}



  Future<bool> deleteRide(int rideId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ridesService.deleteRide(rideId);
      // Odśwież listy przejazdów
      await fetchMyRides();
      await fetchRides();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> progressRide(int rideId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newStatus = await _ridesService.progressRide(rideId);
      // Odśwież bieżący przejazd, jeśli jest ustawiony
      if (_currentRide?.id == rideId) {
        await fetchRideById(rideId);
      }
      // Odśwież listy przejazdów
      await fetchMyRides();
      await fetchRides();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> requestToJoinRide(int rideId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ridesService.requestToJoinRide(rideId);
      // Odśwież szczegóły przejazdu, jeśli jest ustawiony
      if (_currentRide?.id == rideId) {
        await fetchRideById(rideId);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}