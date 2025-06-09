import '../widgets/ride_message.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Przejazdy'),
      ),
      drawer: const AppDrawer(),
      body: const RidesMessageWidget(),
    );
  }
}
