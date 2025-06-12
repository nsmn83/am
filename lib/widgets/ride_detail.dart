import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/ride.dart';

class RideDetailsList extends StatelessWidget {
  final Ride ride;

  const RideDetailsList({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: Text(
              'route'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${ride.startAddress} ${'to'.tr()} ${ride.endAddress}'),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(
              'date_time'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${'start'.tr()}: ${ride.startTime.toString().substring(0, 16)}\n'
                  '${'end'.tr()}: ${ride.endTime.toString().substring(0, 16)}',
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(
              'driver'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(ride.driver?.username ?? 'unknown'.tr()),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(
              'passengers'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${'max'.tr()}: ${ride.maxPassengers}'),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(
              'status'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(ride.status),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(
              'description'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              ride.description.isNotEmpty
                  ? ride.description
                  : 'no_description'.tr(),
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(
              'coordinates'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${'start'.tr()}: (${ride.startLat}, ${ride.startLng})\n'
                  '${'end'.tr()}: (${ride.endLat}, ${ride.endLng})',
            ),
          ),
        ),
        if (ride.requests.isNotEmpty) ...[
          Card(
            child: ListTile(
              title: Text(
                'passenger_requests'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ride.requests.map((request) {
                  return Text(
                    '${'passenger'.tr()}: ${request.person.username ?? 'unknown'.tr()}, ${'status'.tr()}: ${request.status.tr()}',
                  );
                }).toList(),
              ),
            ),
          ),
        Card(
          child: ListTile(
            title: Text(
              'created_at'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(ride.createdAt.toString().substring(0, 16)),
          ),
        ),
      ],
    ]);
  }
}