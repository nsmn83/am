import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rides_provider.dart';
import '../models/ride.dart';

class RidesListWidget extends StatelessWidget {
  final List<Ride>? ridesList;

  const RidesListWidget({super.key, this.ridesList});

  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RidesProvider>(context);

    final ridesToShow = ridesList ?? ridesProvider.rides;

    if (ridesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ridesProvider.error != null) {
      return Center(
        child: Text(
          ridesProvider.error!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    if (ridesToShow.isEmpty) {
      return const Center(child: Text('No rides found. Try searching with different filters.'));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: ridesToShow.length,
        itemBuilder: (context, index) {
          final Ride ride = ridesToShow[index];
          debugPrint('Ride $index: ${ride.toString()}');
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                '${ride.startAddress} to ${ride.endAddress}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${ride.startTime.toString().substring(0, 10)}'),
                  Text('Time: ${ride.startTime.toString().substring(11, 16)}'),
                  Text('Seats: ${ride.maxPassengers}'),
                  Text('Driver: ${ride.driver?.username ?? 'Unknown'}'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/ride_details', arguments: ride);
              },
            ),
          );
        },
      ),
    );
  }
}
