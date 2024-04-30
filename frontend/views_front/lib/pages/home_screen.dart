import 'package:flutter/material.dart';
//import 'package:flutter_jwt/flutter_jwt.dart';

// En HomeScreen.dart
class HomeScreen extends StatelessWidget {
  final String? username; // Nombre de usuario recibido

  const HomeScreen({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            if (username != null) ...[
              Text(
                "¡Hola, $username!", // Mostrar el nombre de usuario
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
