import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rides_provider.dart';

class RidesFilterWidget extends StatefulWidget {
  const RidesFilterWidget({super.key});

  @override
  State<RidesFilterWidget> createState() => _RidesFilterWidgetState();
}

class _RidesFilterWidgetState extends State<RidesFilterWidget> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RidesProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _startController,
            decoration: const InputDecoration(
              labelText: 'Start Address',
            ),
          ),
          TextField(
            controller: _endController,
            decoration: const InputDecoration(
              labelText: 'End Address',
            ),
          ),
          TextField(
            controller: _dateController,
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(
              labelText: 'Date (YYYY-MM-DD)',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
onPressed: () {
  final dateText = _dateController.text.trim();
  DateTime? parsedDate;

  if (dateText.isNotEmpty) {
    parsedDate = DateTime.tryParse(dateText);
    if (parsedDate == null) {
      // Show an error using a dialog or snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid date in YYYY-MM-DD format.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Do not proceed
    }
  }

  ridesProvider.fetchRides(
    startAddress: _startController.text.isNotEmpty ? _startController.text : null,
    endAddress: _endController.text.isNotEmpty ? _endController.text : null,
    date: dateText.isNotEmpty ? dateText : null,
  );
},
            child: const Text('Search Rides'),
          ),
          const SizedBox(height: 16),
          if (ridesProvider.error != null)
            Text(
              ridesProvider.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    );
  }
}