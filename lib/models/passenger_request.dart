import 'user.dart';

class PassengerRequest {
  final int id;
  final User person;
  final int rideId;
  final String status;

  PassengerRequest({
    required this.id,
    required this.person,
    required this.rideId,
    required this.status,
  });

  factory PassengerRequest.fromJson(Map<String, dynamic> json) {
    return PassengerRequest(
      id: json['id'] as int? ?? 0, 
      person: User.fromJson(json['user'] as Map<String, dynamic>),
      rideId: json['ride'] is int ? json['ride'] as int : 0,
      status: json['status'] as String? ?? '',
    );
  }
}