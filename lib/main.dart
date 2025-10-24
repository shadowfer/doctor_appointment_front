import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'package:intl/date_symbol_data_local.dart'; // <--- YA TIENES ESTE IMPORT, ¡EXCELENTE!

// Firebase Init
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // --- AÑADE ESTA LÍNEA AQUÍ ---
  await initializeDateFormatting('es_ES', null);
  // -----------------------------

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Citas Médicas',
      initialRoute: Routes.login,
      onGenerateRoute: Routes.onGenerateRoute,
      // Opcional: Añadir el tema si quieres consistencia
      theme: ThemeData(
        primaryColor:
            kCorporatePrimaryColor, // Asegúrate que kCorporatePrimaryColor esté disponible (ej. desde routes.dart)
        hintColor:
            kCorporateAccentColor, // Asegúrate que kCorporateAccentColor esté disponible
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Estilo AppBar blanco por defecto
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: kCorporateAccentColor,
        ), // Define el color secundario/acento
      ),
      debugShowCheckedModeBanner: false, // Quitar banner debug
    );
  }
}
