import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/ride.dart';

class RidesService {
  final Dio _dio;

  RidesService(this._dio);

  void _logRequest(String method, String path, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters}) {
    debugPrint('--- HTTP Request ---');
    debugPrint('Method: $method');
    debugPrint('URL: ${_dio.options.baseUrl}$path');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      debugPrint('Query Parameters: $queryParameters');
    }
    if (data != null) {
      debugPrint('Body: $data');
    }
    debugPrint('Headers: ${_dio.options.headers}');
    debugPrint('-------------------');
  }

  /// Dodanie do backendu nowego przejazdu
  Future<void> createRide(Map<String, dynamic> rideData) async {
    try {
      _logRequest('POST', 'rides/create/', data: rideData);
      await _dio.post('rides/create/', data: rideData);
    } catch (e) {
      throw Exception('Failed to create ride: $e');
    }
  }



  /// Pobranie przejazdów zalogowanego użytkownika
  Future<List<Ride>> fetchMyRides() async {
    try {
      _logRequest('GET', 'rides/my/');
      final response = await _dio.get('rides/my/');

      if (response.data == null) {
        throw Exception('Response data is null');
      }
      if (response.data is! List) {
        throw Exception('Unexpected response format: expected a List');
      }

      final List<dynamic> data = response.data;
      final filteredData = data.where((element) => element != null && element is Map<String, dynamic>);

      if (filteredData.isEmpty) {
        return [];
      }

      return filteredData.map((json) {
        final safeJson = Map<String, dynamic>.from(json as Map<String, dynamic>);
        if (safeJson['requests'] == null) {
          safeJson['requests'] = [];
        }
        return Ride.fromJson(safeJson);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch my rides: $e');
    }
  }

  /// Pobiera listę przejazdów z backendu i zwraca listę obiektów Ride
  Future<List<Ride>> fetchRides({
    String? startAddress,
    String? endAddress,
    String? date,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (startAddress != null && startAddress.isNotEmpty) {
        queryParameters['start_address'] = startAddress;
      }
      if (endAddress != null && endAddress.isNotEmpty) {
        queryParameters['end_address'] = endAddress;
      }
      if (date != null && date.isNotEmpty) {
        queryParameters['date'] = date;
      }

      _logRequest('GET', 'rides/all/', queryParameters: queryParameters);
      final response = await _dio.get('rides/all/', queryParameters: queryParameters);

      if (response.data == null) {
        throw Exception('Response data is null');
      }
      if (response.data is! List) {
        throw Exception('Unexpected response format: expected a List');
      }

      final List<dynamic> data = response.data;
      final filteredData = data.where((element) => element != null && element is Map<String, dynamic>);

      if (filteredData.isEmpty) {
        return [];
      }

      return filteredData.map((json) {
        final safeJson = Map<String, dynamic>.from(json as Map<String, dynamic>);
        if (safeJson['requests'] == null) {
          safeJson['requests'] = [];
        }
        return Ride.fromJson(safeJson);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch rides: $e');
    }
  }

/// Akceptuje prośbę pasażera
Future<void> acceptPassengerRequest(int requestId) async {
  try {
    _logRequest('POST', 'rides/accept/$requestId/');
    final response = await _dio.post('rides/accept/$requestId/');

    if (response.data['status'] != 'accepted') {
      throw Exception('Failed to accept passenger request: unexpected response');
    }
  } catch (e) {
    throw Exception('Failed to accept passenger request: $e');
  }
}

/// Odrzuca prośbę pasażera
Future<void> rejectPassengerRequest(int requestId) async {
  try {
    _logRequest('POST', 'rides/reject/$requestId/');
    final response = await _dio.post('rides/reject/$requestId/');

    if (response.data['status'] != 'rejected') {
      throw Exception('Failed to reject passenger request: unexpected response');
    }
  } catch (e) {
    throw Exception('Failed to reject passenger request: $e');
  }
}



  /// Pobiera szczegóły pojedynczego przejazdu po ID
  Future<Ride> fetchRideById(int rideId) async {
    try {
      _logRequest('GET', 'rides/$rideId/');
      final response = await _dio.get('rides/$rideId/');
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      final safeJson = Map<String, dynamic>.from(response.data as Map<String, dynamic>);
      if (safeJson['requests'] == null) {
        safeJson['requests'] = [];
      }
      return Ride.fromJson(safeJson);
    } catch (e) {
      throw Exception('Failed to fetch ride details: $e');
    }
  }

  /// Usuwa przejazd o podanym ID
  Future<void> deleteRide(int rideId) async {
    try {
      _logRequest('POST', 'rides/delete/$rideId/');
      final response = await _dio.post('rides/delete/$rideId/');
      if (response.data['status'] != 'deleted') {
        throw Exception('Failed to delete ride: unexpected response');
      }
    } catch (e) {
      throw Exception('Failed to delete ride: $e');
    }
  }

  /// Zmienia status przejazdu (planned -> in_progress -> done)
  Future<String> progressRide(int rideId) async {
    try {
      _logRequest('POST', 'rides/progress/$rideId/');
      final response = await _dio.post('rides/progress/$rideId/');
      final newStatus = response.data['status'] as String?;
      if (newStatus == null || !['in_progress', 'done'].contains(newStatus)) {
        throw Exception('Invalid status returned');
      }
      return newStatus;
    } catch (e) {
      throw Exception('Failed to progress ride: $e');
    }
  }

  /// Wysyła żądanie dołączenia do przejazdu
  Future<void> requestToJoinRide(int rideId) async {
    try {
      final data = {'ride': rideId};
      _logRequest('POST', 'rides/join/', data: data);
      await _dio.post('rides/join/', data: data);
    } catch (e) {
      throw Exception('Failed to request to join ride: $e');
    }
  }

}