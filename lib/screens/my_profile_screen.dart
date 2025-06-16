import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  String? _imageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _imageUrl = user?.image;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final url = await showDialog<String>(
      context: context,
      builder: (context) {
        final urlController = TextEditingController();
        return AlertDialog(
          title: Text('enter_url'.tr()),
          content: TextField(
  controller: urlController,
  decoration: InputDecoration(hintText: 'image_url'.tr()),
  keyboardType: TextInputType.url,
),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(urlController.text.trim()),
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (url != null && url.isNotEmpty) {
      setState(() {
        _imageUrl = url;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateUserProfile(
      bio: _bioController.text,
      image: _imageUrl ?? '',
    );

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('update_profile'.tr())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('update_profile_failed'.tr())),
      );
    }
  }

@override
Widget build(BuildContext context) {
  final user = Provider.of<AuthProvider>(context).user;
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      title: Text('Mój profil'.tr()),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: (_imageUrl != null && _imageUrl!.isNotEmpty)
                    ? NetworkImage(_imageUrl!)
                    : null,
                child: (_imageUrl == null || _imageUrl!.isEmpty)
                    ? Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _pickImage,
              child: Text('change_picture'.tr()),
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Theme.of(context).dividerColor),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Text(
                  '${'username'.tr()}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(user!.username),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Text(
                  'Email: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(user.email),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _bioController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'bio'.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).dividerColor),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('save_changes'.tr()),
            ),
          ),
        ],
      ),
    ),
  );
}
}
