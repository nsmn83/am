//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/rides_provider.dart';
import 'package:geolocator/geolocator.dart';

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
  final _maxPassengersController = TextEditingController();
  DateTime? _startDate;
  TimeOfDay? _startTime;
  String? _location;

  @override
  void dispose() {
    _startAddressController.dispose();
    _endAddressController.dispose();
    _descriptionController.dispose();
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
  }

  String? _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    final dateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute);
    return dateTime.toIso8601String().substring(0, 19);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;


    final maxPassengers = int.tryParse(_maxPassengersController.text);
    final startTime = _formatDateTime(_startDate, _startTime);

    if (startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('select_date_time'.tr())),
      );
      return;
    }
    if (maxPassengers == null || maxPassengers <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('invalid_max_passengers'.tr())),
      );
      return;
    }

    final rideData = {
      'start_address': _startAddressController.text,
      'end_address': _endAddressController.text,
      'start_time': startTime,
      'max_passengers': maxPassengers,
      'description': _descriptionController.text,
    };

    final success = await Provider
        .of<RidesProvider>(context, listen: false)
        .addRide(rideData);

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
          validator: (value) {
    if (value != null && value.length > 200) {
      return 'description_too_long'.tr(); // np. "Opis nie może być dłuższy niż 200 znaków"
    }
    return null;
  },
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
              : '${'selected_date'.tr()}: ${_startDate!.toString().substring(
              0, 10)}',
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
      ElevatedButton(
        onPressed: _getCurrentLocation,
        child: Text('UseLoc'.tr()),
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


  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _location = '';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _location = '';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _location = '';
        });
        return;
      }
      //współrzędne
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Position testPosition = Position(
        latitude: 52.2297,
        longitude: 21.0122,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        headingAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        speedAccuracy: 0.0,
      );

      //reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _startAddressController.text = '${place.locality}';
        });
      } else {
        setState(() {
          _location = '';
        });
      }
    } catch (e) {
      e.toString();
      setState(() {
        _location = '';
      });
    }
  }


}