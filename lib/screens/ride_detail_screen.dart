import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../widgets/ride_detail.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

class RideDetailsScreen extends StatelessWidget {
  final Ride ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final User? currentUser = authProvider.user;

        // DEBUG PRINTS
    print('Current user ID: ${currentUser?.id}');
    print('Ride driver ID: ${ride.driver?.id}');

    final bool isDriver = currentUser != null && ride.driver?.id == currentUser.id;

return Scaffold(
  appBar: AppBar(
    title: const Text('Ride Details'),
  ),
  body: Column(
    children: [
      Expanded(
        child: RideDetailsList(ride: ride), // scrollable list
      ),
      const SizedBox(height: 20),
      if (isDriver) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Zmień status
            },
            child: const Text('Zmień status'),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // Usuń przejazd
            },
            child: const Text('Usuń przejazd'),
          ),
        ),
      ] else if (currentUser != null) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Dołącz do przejazdu
            },
            child: const Text('Dołącz do przejazdu'),
          ),
        ),
      ],
      const SizedBox(height: 16),
    ],
  ),
);

  }
}
