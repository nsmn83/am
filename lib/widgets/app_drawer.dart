//Tutaj znajduje się wysuwany na głównym ekranie pasek boczny

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
            title: const Text('Mój profil'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Moje przejazdy'),
            onTap: () {
              Navigator.pushNamed(context, '/myrides');
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Zmień język'),
            onTap: () {
              // Dodaj logikę zmiany języka
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Zmień motyw'),
            onTap: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Wyloguj się'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
