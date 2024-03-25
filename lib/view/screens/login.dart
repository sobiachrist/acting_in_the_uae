import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'MainScreen.dart';
import 'signup.dart'; // Assuming SignupScreen is in the same directory

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 250,
                height: 100,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _login(context, emailController.text, passwordController.text),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _navigateToSignup(context),
                child: const Text('Not a member? Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context, String email, String password) async {
    const String url = 'http://209.97.163.97:81/api/Account/Login';
    final Map<String, String> body = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(Uri.parse(url), body: body);
      final responseData = json.decode(response.body);
      print('RESPONSE: ${response.body}');

      if (response.statusCode == 200 && responseData['success']) {
        // Save login state to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to MainScreen after successful login
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));

        // Show success message
        _showSnackBar(context, 'Login successful');
      } else {
        // Show error message
        String errorMessage = responseData['message'];
        if (errorMessage == null || errorMessage.isEmpty) {
          errorMessage = 'An error occurred. Please try again later.';
        }
        _showSnackBar(context, errorMessage);
      }
    } catch (e) {
      print('Error: $e');
      // Show error message
      _showSnackBar(context, 'An error occurred. Please try again later.');
    }
  }

  void _navigateToSignup(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
