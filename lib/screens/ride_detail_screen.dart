import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/ride_map.dart';
import '../models/ride.dart';
import '../models/user.dart';
import '../widgets/ride_detail.dart';
import '../providers/auth_provider.dart';
import '../providers/rides_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RidesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final User? currentUser = authProvider.user;

    return Scaffold(
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

          final waitingRequests = ride.requests
              .where((request) => request.status == 'waiting')
              .toList();

          return Column(
            children: [
              Expanded(child: RideDetailsList(ride: ride)),

              if (isDriver && waitingRequests.isNotEmpty) ...[
                ExpansionTile(
                  title: Text('passenger_requests_count'
                      .tr(args: [waitingRequests.length.toString()])),
                  children: waitingRequests.map((request) {
                    return ListTile(
                      title: Text(request.person.username),
                      subtitle: Text('email_label'.tr(args: [request.person.email])),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () async {
                              final success = await ridesProvider
                                  .acceptPassengerRequest(request.id, widget.rideId);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? 'request_accepted'.tr()
                                      : 'request_accept_failed'
                                      .tr(args: [ridesProvider.error ?? ''])),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () async {
                              final success = await ridesProvider
                                  .rejectPassengerRequest(request.id, widget.rideId);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? 'request_rejected'.tr()
                                      : 'request_reject_failed'
                                      .tr(args: [ridesProvider.error ?? ''])),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 20),
              RideMap(
                startLat: ride.startLat,
                startLng: ride.startLng,
                endLat: ride.endLat,
                endLng: ride.endLng,
              ),

              if (isDriver && ride.status != 'done') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await ridesProvider.progressRide(widget.rideId);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'ride_status_updated'.tr()
                              : 'ride_status_update_failed'
                              .tr(args: [ridesProvider.error ?? ''])),
                        ),
                      );
                    },
                    child: Text('change_status'.tr()),
                  ),
                ),
              ],

              if (isDriver) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      final success = await ridesProvider.deleteRide(widget.rideId);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'ride_deleted'.tr()
                              : 'ride_delete_failed'
                              .tr(args: [ridesProvider.error ?? ''])),
                        ),
                      );
                      if (success) Navigator.pop(context);
                    },
                    child: Text('delete_ride'.tr()),
                  ),
                ),
              ] else if (currentUser != null && !hasPendingOrAcceptedRequest) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final success =
                      await ridesProvider.requestToJoinRide(widget.rideId);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'join_request_sent'.tr()
                              : 'join_request_failed'
                              .tr(args: [ridesProvider.error ?? ''])),
                        ),
                      );
                    },
                    child: Text('join_ride'.tr()),
                  ),
                ),
              ],

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}