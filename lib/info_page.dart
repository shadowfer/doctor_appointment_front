import 'package:flutter/material.dart';
import 'routes.dart';

// Constantes de color (se asume que se definen en routes.dart o similar)
const Color kCorporatePrimaryColor = Color(0xFF005691);
const Color kCorporateAccentColor = Color(0xFF14B8A6);

class InfoPage extends StatelessWidget {
  final String title;
  final String content;
  const InfoPage({super.key, required this.title, required this.content});

  List<TextSpan> _buildContentSpans(String text) {
    final List<TextSpan> spans = [];
    final parts = text.split(RegExp(r'\*\*'));

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;

      if (i % 2 == 1) {
        // Texto negrita (dentro de **) en color de acento
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kCorporateAccentColor,
            ),
          ),
        );
      } else {
        // Texto normal
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        );
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kCorporatePrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
          child: Container(
            // --- Estilo de Tarjeta Flotante ---
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            child: RichText(
              text: TextSpan(
                children: _buildContentSpans(content),
                style: const TextStyle(
                  fontSize: 16.0,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
