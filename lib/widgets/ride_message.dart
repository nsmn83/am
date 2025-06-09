import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rides_provider.dart';

class RidesMessageWidget extends StatelessWidget {
  const RidesMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RidesProvider>(
      builder: (context, ridesProvider, child) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: ridesProvider.isLoading
                  ? null
                  : () => ridesProvider.fetchRidesMessage(),
              child: ridesProvider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Fetch Rides Message'),
            ),
            const SizedBox(height: 16.0),
            if (ridesProvider.message.isNotEmpty)
              Text(
                ridesProvider.message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            if (ridesProvider.error != null)
              Text(
                ridesProvider.error!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}