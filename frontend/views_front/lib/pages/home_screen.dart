import 'package:flutter/material.dart';
import 'package:views_front/constants/boton.dart'; // Importa los estilos de botón

class HomeScreen extends StatelessWidget {
  final String accessToken;

  const HomeScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String username = _extractUsername(accessToken);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido, $username!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _showTokenDialog(context, accessToken);
              },
              icon: Icon(Icons.access_time_rounded), // Icono para "Ver Token"
              label: Text('Ver Token'),
              style: ButtonStyles.getButtonStyle(), // Aplicar estilos de botón
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para habilitar algo en la aplicación
              },
              icon: Icon(Icons.fingerprint), // Icono de huella para "Habilitar"
              label: SizedBox(
                width: 160,
                height: 50,
                child: Center(
                  child: Text(
                    'Habilitar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              style: ButtonStyles.getButtonStyle(), // Aplicar estilos de botón
            ),
          ],
        ),
      ),
    );
  }

  String _extractUsername(String accessToken) {
    return 'Usuario';
  }

  void _showTokenDialog(BuildContext context, String accessToken) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Token de Acceso'),
          content: Text(accessToken),
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
