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
    // Dla uproszczenia - wpisz URL zdjęcia w dialogu
    final url = await showDialog<String>(
      context: context,
      builder: (context) {
        final urlController = TextEditingController(text: _imageUrl);
        return AlertDialog(
          title: Text('Enter new image URL'.tr()),
          content: TextField(
  controller: urlController,
  decoration: InputDecoration(hintText: 'Image URL'.tr()),
  keyboardType: TextInputType.url,
),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel'.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(urlController.text.trim()),
              child: Text('OK'.tr()),
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
        SnackBar(content: Text('Profile updated successfully'.tr())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('My Profile'.tr())),
        body: Center(child: Text('User not logged in'.tr())),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
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
            const SizedBox(height: 12),
            TextButton(
              onPressed: _pickImage,
              child: Text('Change profile picture'.tr()),
            ),
            const SizedBox(height: 20),
          Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Row(
    children: [
      Text(
        'Username: ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(user.username),
    ],
  ),
),

// Jeśli chcesz też wyświetlić e-mail:
Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Row(
    children: [
      Text(
        'Email: ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(user.email),
    ],
  ),
),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Save Changes'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
