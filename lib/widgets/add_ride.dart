import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rides_provider.dart';

class AddRideForm extends StatefulWidget {
  const AddRideForm({super.key});

  @override
  _AddRideFormState createState() => _AddRideFormState();
}

class _AddRideFormState extends State<AddRideForm> {
  final _formKey = GlobalKey<FormState>();
  final _startAddressController = TextEditingController();
  final _endAddressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passengerCountController = TextEditingController();
  final _maxPassengersController = TextEditingController();
  DateTime? _startDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _startAddressController.dispose();
    _endAddressController.dispose();
    _descriptionController.dispose();
    _passengerCountController.dispose();
    _maxPassengersController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  String? _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return dateTime.toIso8601String().substring(0, 19);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final passengerCount = int.tryParse(_passengerCountController.text);
    final maxPassengers = int.tryParse(_maxPassengersController.text);
    final startTime = _formatDateTime(_startDate, _startTime);
    final endTime = _formatDateTime(_startDate, _endTime);

    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wybierz datę i godziny!')),
      );
      return;
    }
    if (passengerCount == null || passengerCount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Liczba pasażerów musi być liczbą dodatnią!')),
      );
      return;
    }
    if (maxPassengers == null || maxPassengers <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maksymalna liczba pasażerów musi być liczbą dodatnią!')),
      );
      return;
    }
    if (passengerCount > maxPassengers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Liczba pasażerów nie może przekraczać maksymalnej liczby!')),
      );
      return;
    }

    final rideData = {
      'start_address': _startAddressController.text,
      'end_address': _endAddressController.text,
      'start_time': startTime,
      'end_time': endTime,
      'passenger_count': passengerCount,
      'max_passengers': maxPassengers,
      'description': _descriptionController.text,
    };

    final success = await Provider.of<RidesProvider>(context, listen: false).addRide(rideData);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Przejazd został dodany!')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie udało się dodać przejazdu')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _startAddressController,
            decoration: const InputDecoration(labelText: 'Adres początkowy'),
            validator: (value) => value!.isEmpty ? 'Wymagany adres początkowy' : null,
          ),
          TextFormField(
            controller: _endAddressController,
            decoration: const InputDecoration(labelText: 'Adres końcowy'),
            validator: (value) => value!.isEmpty ? 'Wymagany adres końcowy' : null,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Opis (opcjonalny)'),
          ),
          TextFormField(
            controller: _passengerCountController,
            decoration: const InputDecoration(labelText: 'Liczba pasażerów'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Wymagana liczba pasażerów' : null,
          ),
          TextFormField(
            controller: _maxPassengersController,
            decoration: const InputDecoration(labelText: 'Maksymalna liczba pasażerów'),
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Wymagana maksymalna liczba pasażerów' : null,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              _startDate == null
                  ? 'Wybierz datę'
                  : 'Data: ${_startDate!.toString().substring(0, 10)}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            title: Text(
              _startTime == null
                  ? 'Wybierz godzinę rozpoczęcia'
                  : 'Godzina rozpoczęcia: ${_startTime!.format(context)}',
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectStartTime(context),
          ),
          ListTile(
            title: Text(
              _endTime == null
                  ? 'Wybierz godzinę zakończenia'
                  : 'Godzina zakończenia: ${_endTime!.format(context)}',
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectEndTime(context),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Dodaj przejazd'),
          ),
        ],
      ),
    );
  }
}