import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:views_front/pages/login_screen.dart';
import 'package:views_front/constants/constants.dart';
const Color backgroundColor = Color.fromARGB(255, 153, 176, 207); // Definir el color de fondo
class HomeScreen extends StatelessWidget {
  final String accessToken;
  final bool isFingerprintEnabled;

  const HomeScreen({Key? key, required this.accessToken, this.isFingerprintEnabled = false}) : super(key: key);

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
              'Opciones disponibles: ',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (isFingerprintEnabled) {
                  _disableFingerprint(context);
                } else {
                  _showActivationDialog(context);
                }
              },
              icon: Icon(isFingerprintEnabled ? Icons.cancel : Icons.fingerprint),
              label: Text(isFingerprintEnabled ? 'Deshabilitar Login Alternativo' : 'Habilitar Login Alternativo'),
              style: ButtonStyles.getButtonStyle(), // Aplicar el estilo definido para el botón
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(isLongTokenActivated: isFingerprintEnabled)),
                );
              },
              child: Text('Cerrar Sesión'),
              style: ButtonStyles.getButtonStyle(), // Aplicar el estilo definido para el botón
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
                decoration: InputDecoration(labelText: 'Nombre de Usuario'), // No aplicar estilos aquí
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'), // No aplicar estilos aquí
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
              // No aplicar estilos aquí
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

      // Redirige al usuario a la segunda instancia de la pantalla de inicio
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SecondHomeScreen(accessToken: accessToken, longToken: longToken)),
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

void _disableFingerprint(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deshabilitar Huella'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'), // No aplicar estilos aquí
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'), // No aplicar estilos aquí
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
                _sendDisableFingerprintRequest(context, usernameController.text, passwordController.text);
              },
              child: Text('Aceptar'),
              // No aplicar estilos aquí
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendDisableFingerprintRequest(BuildContext context, String username, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/disable_long_token/');
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Huella deshabilitada correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Redirigir al usuario a la pantalla de inicio de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(isLongTokenActivated: false)),
      );
    } else {
      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al deshabilitar la huella. Por favor, inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class SecondHomeScreen extends StatelessWidget {
  final String accessToken;
  final String longToken;

  const SecondHomeScreen({Key? key, required this.accessToken, required this.longToken}) : super(key: key);

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
              'Opciones disponibles:  ',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Implementa aquí la lógica para deshabilitar el login alternativo
                _disableFingerprint(context);
              },
              icon: Icon(Icons.cancel),
              label: Text('Deshabilitar Login Alternativo'),
              style: ButtonStyles.getButtonStyle(), // Aplicar el estilo definido para el botón
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirige al usuario a la pantalla de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(isLongTokenActivated: true)),
                );
              },
              child: Text('Cerrar Sesión'),
              style: ButtonStyles.getButtonStyle(), // Aplicar el estilo definido para el botón
            ),
          ],
        ),
      ),
    );
  }

  void _disableFingerprint(BuildContext context) {
    // Aquí iría la lógica para deshabilitar el login alternativo
    // Por ejemplo, enviar una solicitud al servidor para desactivar el token de larga duración

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Huella deshabilitada correctamente'),
        backgroundColor: Colors.green,
      ),
    );

    // Redirige al usuario a la pantalla de inicio de sesión con ambas opciones
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(isLongTokenActivated: true)),
    );
  }
}
