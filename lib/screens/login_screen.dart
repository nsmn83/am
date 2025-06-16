import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; 
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

Future<void> _login() async {

  final email = _emailController.text.trim();
  final password = _passwordController.text;

  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final success = await authProvider.login(email, password);

  if (success) {
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('LoginErr'.tr()),
        backgroundColor: Colors.red,
      ),
    );
  }
}


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logowanie'.tr())),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) => Column(
            children: [
              TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Hasło'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('NoAcc'.tr()),
              ),
              SizedBox(height: 20),
              auth.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: Text('Zaloguj'.tr())),
              TextButton(
                onPressed: () {
                  if (context.locale == Locale('pl')) {
                    context.setLocale(Locale('en'));
                  } else {
                    context.setLocale(Locale('pl'));
                  }
                },
                child: Text('Język'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}