//Tutaj znajduje się wysuwany na głównym ekranie pasek boczny

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title:  Text('Mój profil'.tr()),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title:  Text('Moje przejazdy'.tr()),
            onTap: () {
              Navigator.pushNamed(context, '/myrides');
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(('Zmień język'.tr())),
            onTap: () async{
              if(context.locale==Locale('pl'))
                {await context.setLocale(Locale('en'));}
              else {await context.setLocale(Locale('pl'));}
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title:  Text('Zmień motyw'.tr()),
            onTap: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Wyloguj się'.tr()),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
