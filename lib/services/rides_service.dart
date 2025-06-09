import 'package:dio/dio.dart';

class RidesService {
  final Dio _dio;

  RidesService(this._dio);

  /// Pobiera wiadomość o przejazdach z backendu
  Future<String> fetchRidesMessage() async {
    try {
      final response = await _dio.get('rides/all/');
      return response.data['message'] ?? 'No message received';
    } catch (e) {
      throw Exception('Failed to fetch rides message: $e');
    }
  }

  // Możesz dodać więcej metod, np.:
  // Future<List<Ride>> fetchRides() async { ... }
  // Future<void> createRide(Ride ride) async { ... }
}