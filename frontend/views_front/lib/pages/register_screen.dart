import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart'; // Importa LoginScreen
import 'package:views_front/constants/constants.dart';

const Color backgroundColor = Color.fromARGB(255, 153, 176, 207); // Definir el color de fondo
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _register() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String username = _usernameController.text;

    final url = Uri.parse('http://127.0.0.1:8000/register/');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'username': username,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Usuario creado!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registro fallido: ${response.body}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Container(
        color: backgroundColor, // Usar el color de fondo definido en constants.dart
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: labelStyle.copyWith(labelText: 'Correo electrónico'), // Usar el estilo definido para los labels
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _usernameController,
              decoration: labelStyle.copyWith(labelText: 'Nombre de usuario'), // Usar el estilo definido para los labels
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: labelStyle.copyWith(labelText: 'Contraseña'), // Usar el estilo definido para los labels
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _register,
              style: ButtonStyles.getButtonStyle(), // Usar el estilo definido en la clase ButtonStyles
              child: Text('Registrarse'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ButtonStyles.getButtonStyle(), // Usar el estilo definido en la clase ButtonStyles
              child: Text(
                'Ir a Login',
              ),
            )
          ],
        ),
      ),
    );
  }
}
