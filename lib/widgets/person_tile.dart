import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:easy_localization/easy_localization.dart';

class PersonTile extends StatelessWidget {
  final User person;
  final String role;
  final VoidCallback? onTap;
  final Widget? trailing;

  const PersonTile({
    super.key,
    required this.person,
    required this.role,
    this.onTap,
    this.trailing,
  });

  // Statyczna metoda pokazująca dialog z detalami osoby
  static void showPersonDetailsDialog(BuildContext context, User person) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(person.username),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,  // Wyrównanie do lewej
          children: [
            Divider(color: Theme.of(context).dividerColor),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(person.image),
              ),
            ),
            Divider(color: Theme.of(context).dividerColor),
            Text('Email:', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(person.email),
            Divider(color: Theme.of(context).dividerColor),
            Text('bio'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              person.bio.isNotEmpty ? person.bio : 'bio'.tr(),
              textAlign: TextAlign.left,
            ),
            Divider(color: Theme.of(context).dividerColor),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr('close')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
final isPlaceholder = person.id == -1 || person.username == tr('free_spot');

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        isPlaceholder ? CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(person.image),
              )
            : GestureDetector(
                onTap: onTap ?? () => PersonTile.showPersonDetailsDialog(context, person),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(person.image),
                ),
              ),
          const SizedBox(height: 8),
          Text(
            person.username,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '($role)',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
