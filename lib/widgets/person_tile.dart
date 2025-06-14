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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap ?? () => _showPassengerDetailsDialog(context, person),
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
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  static void _showPassengerDetailsDialog(BuildContext context, User passenger) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(passenger.username),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(passenger.image),
            ),
            const SizedBox(height: 12),
            Text('Email: ${passenger.email}'),
            const SizedBox(height: 8),
            Text('bio'.tr()),
            Text(
              passenger.bio.isNotEmpty ? passenger.bio : 'bio'.tr(),
              textAlign: TextAlign.center,
            ),
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
}