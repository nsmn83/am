import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/rides_list.dart';
import '../providers/rides_provider.dart';
// Import AddRideScreen from its own file

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  _MyRidesScreenState createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  @override
  void initState() {
    super.initState();
    // Pobierz przejazdy użytkownika przy inicjalizacji widgetu
    Future.microtask(() => 
      Provider.of<RidesProvider>(context, listen: false).fetchMyRides()
    );
  }

  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RidesProvider>(context);
    final myRides = ridesProvider.myRides; // załóżmy, że fetchMyRides ustawia rides na przejazdy użytkownika

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Moje Przejazdy'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          RidesListWidget(ridesList: myRides),
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

