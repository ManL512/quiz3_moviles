//inicio_screen.dart - pagina 2
import 'package:flutter/material.dart';
import 'package:views_front/pages/register_screen.dart';

class InicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 153, 176, 207), // Color de fondo
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: const Text(
              'Iniciar Quiz',
              style: TextStyle(fontSize: 20.0),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              backgroundColor: const Color.fromARGB(255, 33, 243, 142),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              minimumSize: const Size(200, 50),
            ),
          ),
        ),
      ),
    );
  }
}

