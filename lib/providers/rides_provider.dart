//Provider do danych o przejazdach

import 'package:flutter/foundation.dart';
import '../services/rides_service.dart';
import '../models/ride.dart';

class RidesProvider with ChangeNotifier {
  final RidesService _ridesService;

  RidesProvider(this._ridesService);

  //Informacja czy trwa komunikacja z backendem
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //Tekst bledu
  String? _error;
  String? get error => _error;

  //Pobrane przejazdy 
  List<Ride> _rides = [];
  List<Ride> get rides => _rides;

  //Przejazdy w ktorych aktualnie zalogowany uzytkownik bierze udzial
  List<Ride> _myRides = [];
  List<Ride> get myRides => _myRides;

  //Aktualnie wybrany przejazd
  Ride? _currentRide;
  Ride? get currentRide => _currentRide;

  //Pobranie przejazdow w ktorych udzial bierze zalogowany uzytkownik
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


  //Dodanie przejazdu
  Future<bool> addRide(Map<String, dynamic> rideData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _ridesService.createRide(rideData);
      await fetchRides(); 
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Pobranie przejazdow
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

  //Wcyfoanie przez uzytkownika uczestnictwa / prosby o uczestnictwo w przejezdzie
  Future<bool> withdrawPassengerRequest(int requestId, int userId, int rideId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ridesService.withdrawRequest(requestId, userId);

      // Aktualizacja danych po operacji
      await fetchMyRides();
      await fetchRides();

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

  //Pobranie przejazdu o podanym ID
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

  //Zaakceptowanie prosby o dolaczenie do przejazdu
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

  //Odrzucenie prosby o dolaczenie do przejazdu
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

  //Usuniecie przejazdu
  Future<bool> deleteRide(int rideId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ridesService.deleteRide(rideId);
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

  //Zmiana statusu przejazdu na kolejny (zaplanowany -> w trakcie -> skonoczny)
  Future<bool> progressRide(int rideId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ridesService.progressRide(rideId);
      if (_currentRide?.id == rideId) {
        await fetchRideById(rideId);
      }
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

  //Wyslanie prosby o dolaczenie do przejazdu
  Future<bool> requestToJoinRide(int rideId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ridesService.requestToJoinRide(rideId);
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

  //Zresetowanie danych przechowywanych przez providery
  void reset() {
  _isLoading = false;
  _error = null;
  _rides = [];
  _myRides = [];
  _currentRide = null;
  notifyListeners();
}
}