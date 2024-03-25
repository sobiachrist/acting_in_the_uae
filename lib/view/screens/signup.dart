import 'dart:convert';

import 'package:flutter/material.dart';
import 'login.dart'; // Import the LoginScreen widget
import 'package:http/http.dart' as http;

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    String nameError = '';
    String emailError = '';
    String phoneNumberError = '';
    String passwordError = '';
    String confirmPasswordError = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: nameError.isNotEmpty ? nameError : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: emailError.isNotEmpty ? emailError : null,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  errorText: phoneNumberError.isNotEmpty ? phoneNumberError : null,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: passwordError.isNotEmpty ? passwordError : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  errorText: confirmPasswordError.isNotEmpty ? confirmPasswordError : null,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _validateAndNavigate(context, nameController.text, emailController.text, phoneNumberController.text, passwordController.text, confirmPasswordController.text);
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _navigateToLogin(context);
                },
                child: const Text('Already a member? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _validatePasswordConfirmPassword(String password, String confirmPassword) {
    return password != confirmPassword ? 'Password and confirm password do not match' : '';
  }

  void _validateAndNavigate(BuildContext context, String name, String email, String phoneNumber, String password, String confirmPassword) async {
    var nameError = _validateName(name);
    var emailError = _validateEmail(email);
    var phoneNumberError = _validatePhoneNumber(phoneNumber);
    var passwordError = _validatePassword(password);
    var confirmPasswordError = _validateConfirmPassword(confirmPassword);
    var passwordConfirmPasswordError = _validatePasswordConfirmPassword(password, confirmPassword);

    if (nameError.isEmpty && emailError.isEmpty && phoneNumberError.isEmpty && passwordError.isEmpty && confirmPasswordError.isEmpty && passwordConfirmPasswordError.isEmpty) {
      try {
        final url = Uri.parse('http://209.97.163.97:81/api/Account/Signup');
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': name,
            'email': email,
            'mobile': phoneNumber,
            'password': password,
            // Add other fields as needed
          }),
        );

        print('RESPONSE: ${response.body}');
        print('RESPONSE STATUS CODE: ${response.statusCode}');

        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];

        if (message == 'Email is already registered.') {
          // Handle error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // Success case
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      } catch (e) {
        // Handle any exceptions
        print('Exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Update the UI to show error messages
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nameError.isNotEmpty
                ? nameError
                : emailError.isNotEmpty
                ? emailError
                : phoneNumberError.isNotEmpty
                ? phoneNumberError
                : passwordError.isNotEmpty
                ? passwordError
                : confirmPasswordError.isNotEmpty
                ? confirmPasswordError
                : passwordConfirmPasswordError.isNotEmpty
                ? passwordConfirmPasswordError
                : 'Please fill in all required fields', // Add a default message if none of the error messages are present
          ),
        ),
      );
    }
  }

  String _validateName(String name) {
    return name.isEmpty ? 'Please enter your name.' : '';
  }

  String _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return email.isEmpty ? 'Please enter your email.' : !emailRegex.hasMatch(email) ? 'Please enter a valid email address.' : '';
  }

  String _validatePhoneNumber(String phoneNumber) {
    return phoneNumber.isEmpty || int.tryParse(phoneNumber) == null ? '' : '';
  }

  String _validatePassword(String password) {
    return password.isEmpty ? 'Please enter a password.' : '';
  }

  String _validateConfirmPassword(String cpassword) {
    return cpassword.isEmpty ? 'Please enter a confirm password.' : '';
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
