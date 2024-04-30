import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart'; // Import LoginScreen
import 'package:views_front/constants/boton.dart'; // Importa el archivo con los estilos del botón

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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

    // Basic input validation (optional, consider a more robust approach)
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Prevent proceeding if fields are empty
    }

    // Realize the POST request to the backend
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
        // Registration successful - show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Usuario creado!'), // Use '¡' for exclamation marks
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to LoginScreen (optional)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Registration failed - display error message
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
        title: const Text('Registro'), // Use const constructor
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nombre de usuario'),
            ),            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20.0), // Spacing between fields and buttons

            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrarse'),
              style: ButtonStyles.getButtonStyle(), 
            ),

            const SizedBox(height: 10.0), // Spacing between buttons

        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: const Text(
            'Ir a Login',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.blue, // Cambia el color del texto a azul
            ),
          ),
        )


          ],
        ),
      ),
    );
  }
}
