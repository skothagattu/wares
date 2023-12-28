import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  bool _isPasswordSet = false;
  bool _showReEnterPassword = false;
  String _message = '';
  void _login() async {
    var response = await http.post(
      Uri.parse('https://localhost:44363/api/Auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['setPassword'] == true) {
        // Prompt user to set a password
        setState(() {
          _isPasswordSet = true;
          _showReEnterPassword = true;
          _message = "Please set your password.";
        });
      } else {
        // Successful login

        await prefs.setString('token', data['token']);
        await prefs.setStringList('roles', data['roles'].map<String>((role) => role.toString()).toList());
        // Navigate to the main page
        Navigator.of(context).pushReplacementNamed('/home');

      }
    } else {
      setState(() {
        _message = "Login failed: ${response.body}";
      });
    }
  }

  void _setPassword() async {
    if (_passwordController.text == _rePasswordController.text) {
      var response = await http.post(
        Uri.parse('https://localhost:44363/api/Auth/setPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = "Password set successfully. Please log in again.";
          _showReEnterPassword = false;
          _isPasswordSet = false; // Reset the flag as the password is now set
          _passwordController.clear();
          _rePasswordController.clear();
        });
      } else {
        setState(() {
          _message = "Failed to set password: ${response.body}";
        });
      }
    } else {
      setState(() {
        _message = "Passwords do not match.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/logo_cmi.png'),
            SizedBox(height: 50),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_showReEnterPassword)
              TextField(
                controller: _rePasswordController,
                decoration: InputDecoration(labelText: 'Re-enter Password'),
                obscureText: true,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isPasswordSet) {
                  _setPassword();
                } else {
                  _login();
                }
              },
              child: Text(_isPasswordSet ? 'Set Password' : 'Login'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
