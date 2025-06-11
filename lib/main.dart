import 'package:am_project/screens/my_rides_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/add_ride_screen.dart';
import 'screens/ride_detail_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/rides_provider.dart';
import 'services/rides_service.dart';
import 'models/ride.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        Provider(
          create: (context) => RidesService(
            Provider.of<AuthProvider>(context, listen: false).dio,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RidesProvider(
            Provider.of<RidesService>(context, listen: false),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 225, 255), brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 225, 255), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: themeProvider.currentTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/myrides': (context) => MyRidesScreen(),
        '/add_ride': (context) => const AddRideScreen(),
        '/ride_details': (context) => RideDetailsScreen(
              rideId: ModalRoute.of(context)!.settings.arguments as int,
            ),
      },
    );
  }
}