//main.dart - pagina 1
import 'package:flutter/material.dart';
import 'package:views_front/pages/inicio_screen.dart';
import 'package:views_front/pages/login_screen.dart';
import 'package:views_front/pages/home_screen.dart';
import 'package:views_front/pages/register_screen.dart';
void main() {
  runApp(MaterialApp(
    title: 'QUIZ 3',
    initialRoute: '/', 
    routes: {
      '/': (context) => InicioScreen(), 
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(), 
      '/home': (context) => HomeScreen( username: '', sessionToken: '',),
    },
  ));
}
