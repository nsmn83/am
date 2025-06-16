import 'package:easy_localization/easy_localization.dart';
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
  DateTime? _selectedDate; // Zmienna do przechowywania wybranej daty

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  // Funkcja do wyboru daty za pomocą DatePicker
  Future<void> _selectDate(BuildContext context) async {
    setState(() {
      _selectedDate = null; 
    });
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Formatowanie daty do stringa w formacie YYYY-MM-DD
  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  //Budowanie UI
  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RidesProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _startController,
            decoration: InputDecoration(
              labelText: 'AdresStart'.tr(),
            ),
          ),
          TextField(
            controller: _endController,
            decoration: InputDecoration(
              labelText: 'AdresEnd'.tr(),
            ),
          ),
          ListTile(
            title: Text(
              _selectedDate == null
                  ? 'DateForm'.tr()
                  : '${'DateForm'.tr()}: ${_formatDate(_selectedDate)}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final dateText = _formatDate(_selectedDate);
              ridesProvider.fetchRides(
                startAddress: _startController.text.isNotEmpty ? _startController.text : null,
                endAddress: _endController.text.isNotEmpty ? _endController.text : null,
                date: dateText,
              );
            },
            child: Text('Search Rides'.tr()),
            
          ),
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