import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  final String? sessionToken; // Cambiado a String nullable
  final String username;

  const HomeScreen({Key? key, required this.sessionToken, required this.username}) : super(key: key);

Future<void> enableFingerprint(String username, String password, String? sessionToken, BuildContext context) async {
  if (sessionToken == null) {
    // Manejar el caso en que sessionToken sea null
    print('El token de sesión es nulo.');
    return;
  }
  
  final url = Uri.parse('http://127.0.0.1:8000/fingerprint-login/');

  final requestBody = {
    'username': username,
    'password': password,
    'session_token': sessionToken,
  };

  final response = await http.post(
    url,
    body: json.encode(requestBody),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // La huella se habilitó correctamente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Huella habilitada correctamente.'),
        backgroundColor: Colors.green,
      ),
    );
    // Agregar el mensaje "huella agregada" después de 5 segundos
    Future.delayed(Duration(seconds: 5), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Huella agregada.'),
          backgroundColor: Colors.green,
        ),
      );
    });
  } else {
    // Error al habilitar la huella
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al habilitar la huella: ${response.statusCode}'),
        backgroundColor: Colors.red,
      ),
    );
    print('Mensaje del servidor: ${response.body}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
            Text(
              'Token de sesión:', // Cambiado de 'Token de acceso'
              style: TextStyle(fontSize: 18),
            ),
            Text(
              sessionToken ?? 'N/A', // Usar sessionToken si no es null, de lo contrario mostrar 'N/A'
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String enteredUsername = '';
                String enteredPassword = '';

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Verificación de Credenciales'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: 'Nombre de Usuario'),
                            onChanged: (value) {
                              enteredUsername = value;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'Contraseña'),
                            obscureText: true,
                            onChanged: (value) {
                              enteredPassword = value;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Acción para enviar las credenciales y el token de sesión al backend y habilitar la huella
                            enableFingerprint(enteredUsername, enteredPassword, sessionToken, context); // Cambiado de accessToken a sessionToken
                            Navigator.of(context).pop(); // Cerrar el diálogo modal
                          },
                          child: Text('Confirmar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fingerprint),
                    SizedBox(width: 10),
                    Text('Habilitar Huella'),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 0, 0, 0), 
                backgroundColor: Color.fromARGB(255, 33, 243, 142),
                side: BorderSide(color: Color(0xFF1679AB), width: 2),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para ver artículos
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('Ver Artículos'),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 0, 0, 0), 
                backgroundColor: Color.fromARGB(255, 33, 243, 142),
                side: BorderSide(color: Color(0xFF1679AB), width: 2),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Acción para ver ofertas
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('Ver Ofertas'),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 0, 0, 0), 
                backgroundColor: Color.fromARGB(255, 33, 243, 142),
                side: BorderSide(color: Color(0xFF1679AB), width: 2),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Acción para cerrar sesión
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('Cerrar Sesión'),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 0, 0, 0), 
                backgroundColor: Color.fromARGB(255, 33, 243, 142),
                side: BorderSide(color: Color(0xFF1679AB), width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
