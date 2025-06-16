//szczegoly przejazdu wyswietlane w przenznaczonym do tego ekrani (ride_detail_screen)

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/ride.dart';
import '../models/user.dart';
import 'person_tile.dart';

class RideInfoSection extends StatelessWidget {
  final Ride ride;

  const RideInfoSection({Key? key, required this.ride}) : super(key: key);

  String _translateStatus(String status) {
    switch (status) {
      case 'planned':
        return 'planned'.tr();
      case 'in_progress':
        return 'in_progress'.tr();
      case 'done':
        return 'done'.tr();
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final acceptedRequests = ride.requests.where((r) => r.status == 'accepted').toList();
    final int availableSpots = ride.maxPassengers - acceptedRequests.length;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '${ride.startAddress} - ${ride.endAddress}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Divider(color: Theme.of(context).dividerColor),
          Row(
            children: [
              Text('${'date_time'.tr()}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(ride.startTime.toString().substring(0, 16)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('${'status'.tr()}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(_translateStatus(ride.status)),
            ],
          ),
          const SizedBox(height: 4),
          Text('${'description'.tr()}:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(ride.description.isNotEmpty ? ride.description : 'no_description'.tr()),
          const SizedBox(height: 8),
          Divider(color: Theme.of(context).dividerColor),
          Row(
            children: [
              Text('passengers'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(' (${acceptedRequests.length}/${ride.maxPassengers})'),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              children: [
                if (ride.driver != null)
                  PersonTile(person: ride.driver!, role: tr('driver')),
                ...acceptedRequests.map((r) => PersonTile(person: r.person, role: tr('passenger'))),
                ...List.generate(availableSpots, (index) {
                  return PersonTile(
                    person: User(
                      id: -1,
                      username: tr('free_spot'),
                      email: '',
                      image: 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                      bio: '',
                    ),
                    role: tr('passenger'),
                    onTap: null,
                  );
                }),
              ],
            ),
          ),
          Divider(color: Theme.of(context).dividerColor),
        ],
      ),
    );
  }
}