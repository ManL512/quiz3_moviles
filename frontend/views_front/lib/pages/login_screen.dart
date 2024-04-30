import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:views_front/pages/home_screen.dart';
import 'package:views_front/constants/boton.dart';
import 'package:views_front/pages/register_screen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Flag for loading indicator

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Prepare the credentials map
    final Map<String, String> credentials = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/login/'),
      body: jsonEncode(credentials), // Encode the credentials map to JSON
      headers: {'Content-Type': 'application/json'}, // Set the Content-Type header
    );

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (response.statusCode == 200) {
      // Parse the JSON response body (assuming it contains a message)
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String message = data['message']; // Assuming 'message' is the key

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );

      // Now you can navigate to the HomeScreen
// En la función _login de LoginScreen.dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => HomeScreen(username: username), // Pasar el nombre de usuario
  ),
);

    } else {
      // Handle other status codes
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Hubo un problema. Por favor, inténtalo de nuevo más tarde.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Inicio de sesión'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Add a logo or image here (optional)
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Nombre de usuario'),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Contraseña'),
          ),
          const SizedBox(height: 20.0),
          _isLoading
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: _login,
                  child: const Text('Iniciar sesión'),
                  style: ButtonStyles.getButtonStyle(), // Apply the custom button style
                ),
          const SizedBox(height: 10.0), 
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: const Text(
              'Ir a Registrarse',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}
