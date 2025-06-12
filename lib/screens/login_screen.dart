import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Import AuthProvider
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'LoginErr'.tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //context.setLocale(Locale('en'));
    return Scaffold(
      appBar: AppBar(title: Text('Logowanie'.tr())),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: ('Hasło'.tr())),
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: Text(('Zaloguj'.tr()))),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text(('NoAcc'.tr())),
            ),
            TextButton(
              onPressed: () => {
                if(context.locale==Locale('pl'))context.setLocale(Locale('en'))
                else context.setLocale(Locale('pl'))},
              child: Text('Język'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}