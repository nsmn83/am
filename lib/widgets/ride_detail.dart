import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../models/user.dart';
import '../models/passenger_request.dart';

class RideDetailsList extends StatelessWidget {
  final Ride ride;

  const RideDetailsList({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: const Text(
              'Route',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${ride.startAddress} to ${ride.endAddress}'),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text(
              'Date & Time',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Start: ${ride.startTime.toString().substring(0, 16)}\n'
              'End: ${ride.endTime.toString().substring(0, 16)}',
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text(
              'Driver',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(ride.driver?.username ?? 'Unknown'),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text(
              'Passengers',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Max: ${ride.maxPassengers}'),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(ride.status),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(ride.description.isNotEmpty ? ride.description : 'No description provided'),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text(
              'Coordinates',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Start: (${ride.startLat}, ${ride.startLng})\n'
              'End: (${ride.endLat}, ${ride.endLng})',
            ),
          ),
        ),
        if (ride.requests.isNotEmpty) ...[
          Card(
            child: ListTile(
              title: const Text(
                'Passenger Requests',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ride.requests.map((request) {
                  return Text(
                    'Passenger: ${request.person?.username ?? 'Unknown'}, Status: ${request.status}',
                  );
                }).toList(),
              ),
            ),
          ),
        ],
        Card(
          child: ListTile(
            title: const Text(
              'Created At',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(ride.createdAt.toString().substring(0, 16)),
          ),
        ),
      ],
    );
  }
}