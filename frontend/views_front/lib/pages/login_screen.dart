import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:views_front/pages/home_screen.dart';
import 'package:views_front/constants/constants.dart';

const Color backgroundColor = Color.fromARGB(255, 153, 176, 207); // Definir el color de fondo

class LoginScreen extends StatefulWidget {
  final bool isLongTokenActivated; // Agrega el parámetro isLongTokenActivated

  const LoginScreen({Key? key, this.isLongTokenActivated = false}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _longTokenController = TextEditingController(); // Agrega el controlador para el token de larga duración
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
            builder: (context) => HomeScreen(accessToken: accessToken, isFingerprintEnabled: widget.isLongTokenActivated),
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

  void _loginWithFingerprint() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Autenticación con Huella'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _longTokenController,
                decoration: InputDecoration(labelText: 'Long Token'),
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
                _validateLongToken(_longTokenController.text);
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _validateLongToken(String longToken) async {
    final Map<String, String> data = {'long_token': longToken};
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/validate_long_token/'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String message = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );

        // Navegar a la página de inicio después de validar el token
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(accessToken: longToken, isFingerprintEnabled: true),
          ),
        );
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String error = responseData['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Container(
        color: backgroundColor, // Usar el color de fondo definido en constants.dart
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
            widget.isLongTokenActivated
                ? ElevatedButton(
                    onPressed: _loginWithFingerprint,
                    child: Text('Iniciar Sesión con Huella'),
                  )
                : SizedBox(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), 
      (route) => false, 
    );
  }
}
