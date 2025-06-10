import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/rides_filter.dart';
import '../widgets/rides_list.dart';
import '../widgets/app_drawer.dart';
import '../providers/rides_provider.dart';
import '../providers/auth_provider.dart';
import 'add_ride_screen.dart'; // Import AddRideScreen from its own file

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  _MyRidesScreenState createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  @override
  void initState() {
    super.initState();
    // fetch your rides on init
    Provider.of<RidesProvider>(context, listen: false).fetchMyRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Moje Przejazdy'),
      ),
      body: const Column(
        children: [
          SizedBox(height: 10),
          RidesListWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_ride');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
