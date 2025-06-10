import 'package:dio/dio.dart';
import '../models/ride.dart';

class RidesService {
  final Dio _dio;

  RidesService(this._dio);

  /// Dodanie do backendu nowego przejazdu
  Future<void> createRide(Map<String, dynamic> rideData) async {
  try {
    await _dio.post('rides/create/', data: rideData);
  } catch (e) {
    throw Exception('Failed to create ride: $e');
  }
}

 /// Pobranie przejazdow zalogowanego uzytkownika
Future<List<Ride>> fetchMyRides() async {
  try {
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
}
