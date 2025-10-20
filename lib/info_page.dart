import 'package:flutter/material.dart';
import 'routes.dart'; // Importamos para usar el color kPrimaryColor

/// Widget reutilizable para mostrar pantallas de texto simples.
/// Se usa para 'Privacidad' y 'Sobre Nosotros'.
class InfoPage extends StatelessWidget {
  final String title;
  final String content;
  const InfoPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kPrimaryColor, // Aplicamos el color principal
        elevation: 2,
      ),
      body: SingleChildScrollView(
        // Para asegurar que el texto no se desborde en pantallas pequeñas
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 16.0,
              height: 1.6, // Mejora la legibilidad del texto
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
