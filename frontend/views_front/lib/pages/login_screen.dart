import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:views_front/pages/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isLongTokenActivated; // Agrega el parámetro isLongTokenActivated

  const LoginScreen({Key? key, this.isLongTokenActivated = false}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final Map<String, String> credentials = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/login/'),
        body: jsonEncode(credentials),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String accessToken = data['access'];

        // Aquí podrías guardar el token de acceso en el almacenamiento seguro
        // para utilizarlo posteriormente en otras solicitudes al servidor.

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(accessToken: accessToken),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Credenciales inválidas. Por favor, inténtalo de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error durante la solicitud HTTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hubo un problema. Por favor, inténtalo de nuevo más tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nombre de Usuario'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Iniciar Sesión'),
                  ),
            SizedBox(height: 20.0),
            // Mostrar el botón "Iniciar Sesión con Huella" solo si isLongTokenActivated es true
            widget.isLongTokenActivated
                ? ElevatedButton(
                    onPressed: () {
                      // Implementa aquí la lógica para iniciar sesión con huella (token de larga duración)
                      _loginWithFingerprint();
                    },
                    child: Text('Iniciar Sesión con Huella'),
                  )
                : SizedBox(), // Si no se activa el token de larga duración, no mostrar este botón
          ],
        ),
      ),
    );
  }

  void _loginWithFingerprint() {
    // Implementa aquí la lógica para iniciar sesión con huella (token de larga duración)
    // Por ejemplo, puedes mostrar un diálogo para la autenticación con huella
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Autenticación con Huella'),
          content: Text('Por favor, coloca tu dedo en el sensor de huella para iniciar sesión.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
