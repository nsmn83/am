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
}