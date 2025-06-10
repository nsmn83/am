import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../widgets/ride_detail.dart';

class RideDetailsScreen extends StatelessWidget {
  final Ride ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RideDetailsList(ride: ride),
      ),
    );
  }
}