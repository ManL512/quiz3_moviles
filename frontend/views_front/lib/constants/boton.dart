//'package:views_front/constants/boton.dart'
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
