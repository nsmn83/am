import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/add_ride.dart';

class AddRideScreen extends StatefulWidget {
  const AddRideScreen({super.key}); // Add const constructor if needed

  @override
  _AddRideScreenState createState() => _AddRideScreenState();
}

class _AddRideScreenState extends State<AddRideScreen> {  // <-- extends State<AddRideScreen>
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Dodaj Przejazd'.tr()),
      ),
      body: const AddRideForm(),
    );
  }
}
