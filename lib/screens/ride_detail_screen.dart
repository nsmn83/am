import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ride_map.dart';
import '../widgets/person_tile.dart';
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
      Provider.of<RidesProvider>(context, listen: false).fetchRideById(widget.rideId);
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
            Text('bio'.tr()),
            Text(
              passenger.bio.isNotEmpty ? passenger.bio : 'bio'.tr(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr('close'.tr())),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerRequestTile({
    required User passenger,
    required VoidCallback onAccept,
    required VoidCallback onReject,
  }) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => _showPassengerDetailsDialog(passenger),
        child: CircleAvatar(
          backgroundImage: NetworkImage(passenger.image),
        ),
      ),
      title: Text(passenger.username),
      subtitle: Text('Email: ${passenger.email}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: onAccept,
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: onReject,
          ),
        ],
      ),
    );
  }

  Widget _buildRideInfoSection(Ride ride) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'route'.tr()}: ${ride.startAddress} - ${ride.endAddress}',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
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
              Text(ride.status),
            ],
          ),
          const SizedBox(height: 4),
          Text('${'description'.tr()}:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(ride.description.isNotEmpty ? ride.description : 'no_description'.tr()),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('passengers'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(' (${ride.requests.where((r) => r.status == 'accepted').length}/${ride.maxPassengers})'),
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
                ...ride.requests
                    .where((r) => r.status == 'accepted')
                    .map((r) => PersonTile(person: r.person, role: tr('passenger')))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerRequestsExpansion(RidesProvider ridesProvider, List requests) {
    return ExpansionTile(
      title: Text('${tr('passenger_requests')} (${requests.length})'),
      children: requests.map<Widget>((request) {
        return _buildPassengerRequestTile(
          passenger: request.person,
          onAccept: () async {
            final success = await ridesProvider.acceptPassengerRequest(request.id, widget.rideId);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
  success
    ? tr('request_accepted')
    : tr('request_accept_failed', args: [ridesProvider.error ?? '']),
),
              ),
            );
          },
          onReject: () async {
            final success = await ridesProvider.rejectPassengerRequest(request.id, widget.rideId);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
             content: Text(
  success
    ? tr('request_rejected')
    : tr('request_reject_failed', args: [ridesProvider.error ?? '']),
),
              ),
            );
          },
        );
      }).toList(),
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
        title: Text('ride_details'.tr()),
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
            return Center(child: Text('ride_not_found'.tr()));
          }

          final bool isDriver = currentUser != null && ride.driver?.id == currentUser.id;
          final bool hasPendingOrAcceptedRequest = currentUser != null &&
              ride.requests.any((request) =>
                  request.person.id == currentUser.id &&
                  (request.status == 'waiting' || request.status == 'accepted'));

          final waitingRequests = ride.requests.where((request) => request.status == 'waiting').toList();

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
                          _buildRideInfoSection(ride),
                        ],
                      ),

                      if (isDriver && waitingRequests.isNotEmpty)
                        _buildPassengerRequestsExpansion(ridesProvider, waitingRequests),

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
                               content: Text(
  success
    ? tr('ride_status_updated')
    : tr('ride_status_update_failed', args: [ridesProvider.error ?? '']),
),
                                ),
                              );
                            },
                            child: Text('change_status'.tr()),
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
             content: Text(
  success
    ? tr('ride_deleted')
    : tr('ride_delete_failed', args: [ridesProvider.error ?? '']),
),
                                ),
                              );

                              if (success) navigator.pop();
                            },
                            child: Text('delete_ride'.tr()),
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
             content: Text(
  success
    ? tr('join_request_sent')
    : tr('join_request_failed', args: [ridesProvider.error ?? '']),
),
                                ),
                              );
                            },
                            child: Text('join_ride'.tr()),
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
