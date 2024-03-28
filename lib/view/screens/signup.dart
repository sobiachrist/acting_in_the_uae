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
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40), // Add top margin
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 280,
                        height: 100,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                _buildTextField(nameController, 'Name'),
                const SizedBox(height: 16),
                _buildTextField(emailController, 'Email'),
                SizedBox(height: 20),
                _buildTextField(phoneNumberController, 'Phone Number'),
                SizedBox(height: 20),
                _buildTextField(passwordController, 'Password',
                    isObscure: true),
                SizedBox(height: 6),
                const SizedBox(height: 16),
                _buildTextField(confirmPasswordController, 'Confirm Password',
                    isObscure: true),
                SizedBox(height: 6),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50, // Increase button height
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 80),
                    // Adjust left and right margins
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate email and password
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final phonenumber = phoneNumberController.text.trim();
                        final password = passwordController.text.trim();
                        final cpassword = confirmPasswordController.text.trim();
                        if (name.isEmpty) {
                          _showSnackBar(context, 'Please enter name.');
                        } else if (email.isEmpty) {
                          _showSnackBar(context, 'Please enter an email.');
                        } else if (!isValidEmail(email)) {
                          _showSnackBar(context, 'Please enter a valid email.');
                        } else if (phonenumber.isEmpty) {
                          _showSnackBar(context, 'Please enter phone number.');
                        } else if (password.isEmpty) {
                          _showSnackBar(context, 'Please enter a password.');
                        } else if (cpassword.isEmpty) {
                          _showSnackBar(
                              context, 'Please enter confirm password.');
                        } else {
                          _validateAndNavigate(
                              context,
                              nameController.text,
                              emailController.text,
                              phoneNumberController.text,
                              passwordController.text,
                              confirmPasswordController.text);
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(0), // Square border
                          ),
                        ),
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 14, // Adjust the font size as needed
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  // Add bottom margin
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already a member?"),
                        SizedBox(width: 5),
                        // Add some space between the text and the link
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 14, // Adjust the font size as needed
                            color:
                                Colors.deepPurple, // Customize the text color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  String _validatePasswordConfirmPassword(
      String password, String confirmPassword) {
    return password != confirmPassword
        ? 'Password and confirm password do not match'
        : '';
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isObscure = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      // Adjust left and right margins
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: labelText,
          hintStyle: TextStyle(color: Colors.grey[300]),
          // Change hint text color to light grey
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          // Adjust padding as needed
          border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(0), // Square border
          ),
        ),
      ),
    );
  }

  void _validateAndNavigate(BuildContext context, String name, String email,
      String phoneNumber, String password, String confirmPassword) async {
    var nameError = _validateName(name);
    var emailError = _validateEmail(email);
    var phoneNumberError = _validatePhoneNumber(phoneNumber);
    var passwordError = _validatePassword(password);
    var confirmPasswordError = _validateConfirmPassword(confirmPassword);
    var passwordConfirmPasswordError =
        _validatePasswordConfirmPassword(password, confirmPassword);

    if (nameError.isEmpty &&
        emailError.isEmpty &&
        phoneNumberError.isEmpty &&
        passwordError.isEmpty &&
        confirmPasswordError.isEmpty &&
        passwordConfirmPasswordError.isEmpty) {
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

        if (jsonResponse['statusCode'] == 200){

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));

        }

        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 2),
            ),
          );


        }

      } catch (e) {
        // Handle any exceptions
        print('Exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again later.'),
            duration: Duration(seconds: 2),
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
    return email.isEmpty
        ? 'Please enter your email.'
        : !emailRegex.hasMatch(email)
            ? 'Please enter a valid email address.'
            : '';
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
