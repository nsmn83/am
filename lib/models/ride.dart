import 'user.dart';
import 'passenger_request.dart';

class Ride {
  final int id;
  final User? driver; // Made nullable
  final List<PassengerRequest> requests;
  final String startAddress;
  final String endAddress;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final DateTime startTime;
  final int maxPassengers;
  final DateTime createdAt;
  final String status;
  final String description;

  Ride({
    required this.id,
    this.driver, // Nullable
    required this.requests,
    required this.startAddress,
    required this.endAddress,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.startTime,
    required this.maxPassengers,
    required this.createdAt,
    required this.status,
    required this.description,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] as int? ?? 0, 
      driver: json['driver'] != null ? User.fromJson(json['driver'] as Map<String, dynamic>) : null,
      requests: (json['requests'] as List<dynamic>? ?? [])
          .where((item) => item != null) 
          .map((item) => PassengerRequest.fromJson(item as Map<String, dynamic>))
          .toList(),
      startAddress: json['start_address'] as String? ?? '',
      endAddress: json['end_address'] as String? ?? '',
      startLat: (json['start_lat'] as num?)?.toDouble() ?? 0.0,
      startLng: (json['start_lng'] as num?)?.toDouble() ?? 0.0,
      endLat: (json['end_lat'] as num?)?.toDouble() ?? 0.0,
      endLng: (json['end_lng'] as num?)?.toDouble() ?? 0.0,
      startTime: json['start_time'] != null ? DateTime.parse(json['start_time'] as String) : DateTime.now(),
      maxPassengers: json['max_passengers'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      status: json['status'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}