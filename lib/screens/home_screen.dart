import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/rides_filter.dart';
import '../widgets/rides_list.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text('Przejazdy'.tr()),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16), // zapobiega ścinaniu ostatniego elementu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RidesFilterWidget(),
              Divider(color: Theme.of(context).dividerColor),
              RidesListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
