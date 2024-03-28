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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/logo.png'),
                          width: 280,
                          height: 100,
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    _buildTextField(emailController, 'Email'),
                    SizedBox(height: 20),
                    _buildTextField(passwordController, 'Password', isObscure: true),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 0), // Adjust right and top padding
                          child: TextButton(
                            onPressed: () {
                              // Add your forget password functionality here
                            },
                            child: const Text('Forgot password?',
                              style: TextStyle(
                                fontSize: 13, // Adjust the font size as needed
                              ),),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50, // Increase button height
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 80), // Adjust left and right margins
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate email and password
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            if (email.isEmpty) {
                              _showSnackBar(context, 'Please enter an email.');
                            } else if (!isValidEmail(email)) {
                              _showSnackBar(context, 'Please enter a valid email.');
                            } else if (password.isEmpty) {
                              _showSnackBar(context, 'Please enter a password.');
                            } else {
                              _login(context, email, password);
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0), // Square border
                              ),
                            ),
                          ),
                          child: const Text('Login',
                            style: TextStyle(
                              fontSize: 14, // Adjust the font size as needed
                            ),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0), // Add bottom margin
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()), // Replace SignupScreen with the actual name of your signup screen class
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?"),
                      SizedBox(width: 5), // Add some space between the text and the link
                      Text(
                        "Signup",
                        style: TextStyle(
                          fontSize: 14, // Adjust the font size as needed
                          color: Colors.deepPurple, // Customize the text color
                        ),
                      ),
                    ],
                  ),
                ),

            ),
          ],
        ),
      ),
    );

  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool isObscure = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), // Adjust left and right margins
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: TextStyle(color: Colors.grey[300]), // Change hint text color to light grey
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Adjust padding as needed
          border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(0), // Square border
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context, String email, String password) async {
    final url = Uri.parse('http://209.97.163.97:81/api/Account/Login');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    try {
      final responseData = json.decode(response.body);
      print('RESPONSE: ${response.body}');

      if (responseData['statusCode'] == 200) {
        // Save login state to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to MainScreen after successful login
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen()));

        // Show success message
        _showSnackBar(context, responseData['message']);
      } else {
        // Show error message
        String errorMessage = responseData['message'];
        if (errorMessage.isEmpty) {
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

  bool isValidEmail(String email) {
    // Regular expression pattern for validating email addresses
    // This pattern checks for a string that starts with one or more word characters (\w+), followed by an '@' symbol,
    // followed by one or more word characters (\w+), followed by a dot (.), followed by two or more word characters (\w{2,})
    final RegExp emailRegex = RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

}
