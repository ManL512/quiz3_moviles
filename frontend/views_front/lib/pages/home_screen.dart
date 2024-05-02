import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart'; // Importa LoginScreen

class HomeScreen extends StatelessWidget {
  final String accessToken;

  const HomeScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Implementa aquí la lógica para habilitar el login alternativo
                _showActivationDialog(context);
              },
              icon: Icon(Icons.fingerprint),
              label: Text('Habilitar Login Alternativo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirige al usuario a la pantalla de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }

  void _showActivationDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Activar Login Alternativo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _activateLongToken(context, usernameController.text, passwordController.text);
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _activateLongToken(BuildContext context, String username, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/activate_long_token/');
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String longToken = data['long_token'];

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token de larga duración activado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Redirige al usuario a la pantalla de inicio de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(isLongTokenActivated: true)),
      );
    } else {
      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al activar el token de larga duración'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
