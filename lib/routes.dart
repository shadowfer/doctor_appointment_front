import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'messages_page.dart';
import 'settings_page.dart';
import 'profile_page.dart';
import 'info_page.dart'; // Asegúrate de que este archivo exista
import 'crear_cita_page.dart'; // Importa la página de creación
import 'editar_cita_page.dart'; // Importa la página de edición
import 'models/cita_model.dart'; // Importa el modelo Cita para el manejo de argumentos

// --- CONSTANTES DE COLOR CORPORATIVO ---
const Color kCorporatePrimaryColor = Color(
  0xFF005691,
); // Azul Oscuro (Primario)
const Color kCorporateAccentColor = Color(0xFF14B8A6); // Teal/Cyan (Acento)
// Alias para compatibilidad o usos específicos
const Color kPrimaryColor = kCorporatePrimaryColor;
const Color kPrimaryLightColor = Color(0xFFE6E0FF); // Color light
// ----------------------------------------

const String kPrivacyContent = """
Tu privacidad es fundamental para nosotros en DoctorAppointmentApp.

1.  **Recopilación de Datos:** Solo recopilamos la información que proporcionas voluntariamente en tu perfil (nombre, teléfono, padecimientos) con el fin de facilitar la programación de citas médicas.
2.  **Uso de la Información:** Tus datos personales se utilizan exclusivamente para identificarte dentro de la aplicación y para que los profesionales de la salud puedan contactarte.
3.  **Seguridad:** Empleamos los servicios seguros de Firebase Firestore para almacenar tu información, protegiéndola con altos estándares de seguridad.
4.  **Terceros:** Te aseguramos que no compartimos tu información personal con terceros sin tu consentimiento explícito.
""";

const String kAboutContent = """
**DoctorAppointmentApp v1.0.0**

Esta aplicación es un proyecto demostrativo desarrollado como parte de la "Actividad #6: Navegación entre pantallas".

**Objetivo:**
Implementar un flujo de navegación completo y funcional en Flutter, conectando cuatro pantallas principales (Inicio, Mensajes, Configuración y Perfil) y utilizando Firebase para la gestión de usuarios y datos.

**Tecnologías Utilizadas:**
-   Framework: Flutter & Dart
-   Backend: Firebase Authentication & Cloud Firestore
""";

class Routes {
  // Rutas Principales
  static const String login = '/';
  static const String home = '/home';
  static const String messages = '/messages';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String privacy = '/privacy';
  static const String aboutUs = '/aboutUs';

  // --- RUTAS PARA EL CRUD DE CITAS ---
  static const String crearCita = '/crearCita';
  static const String editarCita =
      '/editarCita'; // Ruta para editar (manejará argumentos)
  // ---------------------------------

  // Mapa de rutas sin argumentos
  static final Map<String, WidgetBuilder> _routesMap = {
    login: (context) => const LoginPage(),
    home: (context) => const HomePage(),
    messages: (context) => const MessagesPage(),
    settings: (context) => const SettingsPage(),
    profile: (context) => const ProfilePage(),
    privacy:
        (context) => const InfoPage(
          title: 'Política de Privacidad',
          content: kPrivacyContent,
        ),
    aboutUs:
        (context) => const InfoPage(
          title: 'Sobre DoctorAppointmentApp',
          content: kAboutContent,
        ),
    // Mapeo de la ruta de creación (sin argumentos)
    crearCita: (context) => const CrearCitaPage(),
  };

  // Generador de rutas que maneja argumentos
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // --- MANEJO DE LA RUTA /editarCita CON ARGUMENTOS ---
    if (settings.name == editarCita) {
      // Intenta extraer el argumento 'Cita'
      final citaParaEditar =
          settings.arguments as Cita?; // Castea al modelo Cita
      if (citaParaEditar != null) {
        // Si el argumento es válido, crea la ruta a EditarCitaPage
        return MaterialPageRoute(
          builder:
              (context) => EditarCitaPage(
                cita: citaParaEditar,
              ), // Pasa la cita al constructor
        );
      } else {
        // Si no hay argumentos o son incorrectos, muestra un error
        return _errorRoute('Argumentos inválidos para la ruta $editarCita');
      }
    }
    // -----------------------------------------------------

    // Busca rutas estándar sin argumentos en el mapa
    final builder = _routesMap[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    // Si la ruta no se encuentra, muestra la página de error
    return _errorRoute(settings.name);
  }

  // Página de error estilizada
  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder:
          (context) => Scaffold(
            appBar: AppBar(
              title: const Text(
                "Error de Navegación",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: kCorporatePrimaryColor, // Color corporativo
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Text('Ruta no definida: ${routeName ?? 'desconocida'}'),
            ),
          ),
    );
  }
}
