import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle getButtonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      backgroundColor: const Color.fromARGB(255, 33, 243, 142),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      minimumSize: Size(200, 50),
    );
  }
}

// Definir el estilo del botón
final buttonStyle = ElevatedButton.styleFrom(
  elevation: 4,
  shadowColor: Colors.grey.withOpacity(0.5),
  padding: EdgeInsets.symmetric(vertical: 14.0),
);

// Definir el estilo del botón de texto
final textButtonStyle = TextButton.styleFrom(
  padding: EdgeInsets.zero,
  minimumSize: Size.zero,
);

// Definir el estilo del texto del botón de texto
final buttonTextTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.blue,
);

// Definir el color de fondo
const Color backgroundColor = Color.fromARGB(255, 153, 176, 207);

// Definir el estilo de los labels con drop shadow sutil
final labelStyle = InputDecoration(
  border: OutlineInputBorder(),
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  // Agregar sombra sutil
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(8.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(8.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(8.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(8.0),
  ),
  errorStyle: TextStyle(color: Colors.red),
);
