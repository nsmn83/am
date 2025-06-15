import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rides_provider.dart';
import '../models/ride.dart';
import 'package:easy_localization/easy_localization.dart';

class RidesListWidget extends StatelessWidget {
  final List<Ride>? ridesList;

  const RidesListWidget({super.key, this.ridesList});

  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RidesProvider>(context);
    final ridesToShow = ridesList ?? ridesProvider.rides;

    // Wymusza aktualizację widgetu przy zmianie języka
    final _ = context.locale;

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

    return ListView.builder(
      shrinkWrap: true,
physics: NeverScrollableScrollPhysics(),
        itemCount: ridesToShow.length,
        itemBuilder: (context, index) {
          final Ride ride = ridesToShow[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(ride.driver!.image),
              ),
              title: Text(
                '${ride.startAddress} - ${ride.endAddress}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'date'.tr()}: ${ride.startTime.toString().substring(0, 10)} '
                    '${'time'.tr()}: ${ride.startTime.toString().substring(11, 16)}',
                  ),
                  Text(
                    '${'driver'.tr()}: ${ride.driver?.username ?? 'Unknown'}',
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/ride_details',
                  arguments: ride.id,
                );
              },
            ),
          );
        },
      );
  }
}
