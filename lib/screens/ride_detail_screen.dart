

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ride_map.dart';
import '../models/ride.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/rides_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class RideDetailsScreen extends StatefulWidget {
  final int rideId;

  const RideDetailsScreen({super.key, required this.rideId});

  @override
  _RideDetailsScreenState createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ridesProvider = Provider.of<RidesProvider>(context, listen: false);
      ridesProvider.fetchRideById(widget.rideId);
    });
  }

void _showPassengerDetailsDialog(User passenger) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(passenger.username),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(passenger.image),
          ),
          const SizedBox(height: 12),
          Text('Email: ${passenger.email}'),
          const SizedBox(height: 8),
          Text('Bio:'),
          Text(
            passenger.bio.isNotEmpty ? passenger.bio : 'bio',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(tr('Close')),
        ),
      ],
    ),
  );
}


@override
Widget build(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  final User? currentUser = authProvider.user;

  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      title: const Text('Ride Details'),
    ),
    body: Consumer<RidesProvider>(
      builder: (context, ridesProvider, child) {
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

        final Ride? ride = ridesProvider.currentRide;

        if (ride == null) {
          return const Center(child: Text('Ride not found.'));
        }

        final bool isDriver = currentUser != null && ride.driver?.id == currentUser.id;
        final bool hasPendingOrAcceptedRequest = currentUser != null &&
            ride.requests.any((request) =>
                request.person.id == currentUser.id &&
                (request.status == 'waiting' || request.status == 'accepted'));

        final waitingRequests = ride.requests
            .where((request) => request.status == 'waiting')
            .toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 650,
                      child: RideMap(
                        startLat: ride.startLat,
                        startLng: ride.startLng,
                        endLat: ride.endLat,
                        endLng: ride.endLng,
                      ),
                    ),

                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${'route'.tr()}: ${ride.startAddress} → ${ride.endAddress}',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${'date_time'.tr()}:',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${ride.startTime.toString().substring(0, 16)}\n'
                                ),
                                const SizedBox(height: 8),
Container(
 
  child: SizedBox(
    
    height: 140, // wysokość kafelków z avatarami
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      children: [
        if (ride.driver != null)
         Container(
  width: 100,
  margin: const EdgeInsets.only(right: 12),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () => _showPassengerDetailsDialog(ride.driver!),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(ride.driver!.image),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        ride.driver!.username,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
      Text(
        '(${tr('driver')})',
        style: const TextStyle(fontSize: 12),
      ),
    ],
  ),
),
        ...ride.requests
    .where((r) => r.status == 'accepted')
    .map(
      (r) => Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _showPassengerDetailsDialog(r.person),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(r.person.image),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              r.person.username,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '(${tr('passenger')})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    )
    .toList(),
      ],
    ),
  ),
),




                              
                                Text('${'passengers'.tr()} (${ride.requests.where((request) => request.status == 'accepted').length}/${ride.maxPassengers})'),
                                const SizedBox(height: 4),
                                Text('${'status'.tr()}: ${ride.status}'),
                                const SizedBox(height: 8),
                                Text(
                                  '${'description'.tr()}:',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(ride.description.isNotEmpty ? ride.description : 'no_description'.tr()),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
        
                      ],
                    ),

                    if (isDriver && waitingRequests.isNotEmpty) 
                      ExpansionTile(
                        title: Text('Prośby pasażerów (${waitingRequests.length})'),
                        children: waitingRequests.map((request) {
                          return ListTile(
                            title: Text(request.person.username),
                            subtitle: Text('Email: ${request.person.email}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () async {
                                    final success = await ridesProvider.acceptPassengerRequest(request.id, widget.rideId);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(success ? 'Prośba zaakceptowana' : 'Nie udało się zaakceptować prośby: ${ridesProvider.error}'),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () async {
                                    final success = await ridesProvider.rejectPassengerRequest(request.id, widget.rideId);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(success ? 'Prośba odrzucona' : 'Nie udało się odrzucić prośby: ${ridesProvider.error}'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 16),

                    if (isDriver && ride.status != 'done')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await ridesProvider.progressRide(widget.rideId);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success
                                    ? 'Ride status updated successfully'
                                    : 'Failed to update ride status: ${ridesProvider.error}'),
                              ),
                            );
                          },
                          child: const Text('Zmień status'),
                        ),
                      ),

                    if (isDriver)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () async {
  final messenger = ScaffoldMessenger.of(context);
final navigator = Navigator.of(context);

final success = await ridesProvider.deleteRide(widget.rideId);

if (!mounted) return;

messenger.showSnackBar(
  SnackBar(
    content: Text(success
        ? 'Ride deleted successfully'
        : 'Failed to delete ride: ${ridesProvider.error}'),
  ),
);

if (success) navigator.pop();

  
},
                          child: const Text('Usuń przejazd'),
                        ),
                      )
                    else if (currentUser != null && !hasPendingOrAcceptedRequest)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await ridesProvider.requestToJoinRide(widget.rideId);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success
                                    ? 'Request to join ride sent successfully'
                                    : 'Failed to send join request: ${ridesProvider.error}'),
                              ),
                            );
                          },
                          child: const Text('Dołącz do przejazdu'),
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
}
