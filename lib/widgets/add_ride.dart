import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
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
        SnackBar(content: Text('select_date_time'.tr())),
      );
      return;
    }
    if (passengerCount == null || passengerCount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('invalid_passenger_count'.tr())),
      );
      return;
    }
    if (maxPassengers == null || maxPassengers <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('invalid_max_passengers'.tr())),
      );
      return;
    }
    if (passengerCount > maxPassengers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('passenger_exceeds_max'.tr())),
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
          SnackBar(content: Text('ride_added_success'.tr())),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ride_add_failed'.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale; // wymusza rebuild przy zmianie języka

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _startAddressController,
            decoration: InputDecoration(labelText: 'start_address'.tr()),
            validator: (value) =>
            value!.isEmpty ? 'start_address_required'.tr() : null,
          ),
          TextFormField(
            controller: _endAddressController,
            decoration: InputDecoration(labelText: 'end_address'.tr()),
            validator: (value) =>
            value!.isEmpty ? 'end_address_required'.tr() : null,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'description_optional'.tr()),
          ),
          TextFormField(
            controller: _passengerCountController,
            decoration: InputDecoration(labelText: 'passenger_count'.tr()),
            keyboardType: TextInputType.number,
            validator: (value) =>
            value!.isEmpty ? 'passenger_count_required'.tr() : null,
          ),
          TextFormField(
            controller: _maxPassengersController,
            decoration: InputDecoration(labelText: 'max_passengers'.tr()),
            keyboardType: TextInputType.number,
            validator: (value) =>
            value!.isEmpty ? 'max_passengers_required'.tr() : null,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              _startDate == null
                  ? 'select_date'.tr()
                  : '${'selected_date'.tr()}: ${_startDate!.toString().substring(0, 10)}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            title: Text(
              _startTime == null
                  ? 'select_start_time'.tr()
                  : '${'start_time'.tr()}: ${_startTime!.format(context)}',
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectStartTime(context),
          ),
          ListTile(
            title: Text(
              _endTime == null
                  ? 'select_end_time'.tr()
                  : '${'end_time'.tr()}: ${_endTime!.format(context)}',
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectEndTime(context),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('add_ride'.tr()),
          ),
        ],
      ),
    );
  }
}