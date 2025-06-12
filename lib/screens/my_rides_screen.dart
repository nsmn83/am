import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/rides_list.dart';
import '../providers/rides_provider.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  _MyRidesScreenState createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user's rides on widget initialization
    Future.microtask(() => 
      Provider.of<RidesProvider>(context, listen: false).fetchMyRides()
    );
  }

  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RidesProvider>(context);
    final myRides = ridesProvider.myRides;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title:  Text('Moje Przejazdy'.tr()),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          RidesListWidget(ridesList: myRides),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddRideScreen and wait for result
          final result = await Navigator.pushNamed(context, '/add_ride');
          if (result == true && mounted) {
            // Reload rides if a ride was added successfully
            await Provider.of<RidesProvider>(context, listen: false).fetchMyRides();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}