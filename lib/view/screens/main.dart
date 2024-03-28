import 'package:acting_in_the_uae/view/screens/login.dart';
import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(), // Check login status
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final isLoggedIn = snapshot.data ??
              false; // Default to false if snapshot data is null
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              textTheme: const TextTheme(
                bodySmall: TextStyle(color: Colors.grey), // Change hint text color to grey
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: isLoggedIn ? MainScreen() : const LoginScreen(),
          );
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ??
        false; // Default to false if no value found
  }
}
