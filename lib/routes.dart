import 'package:flutter/material.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'messages_page.dart';
import 'settings_page.dart';
import 'profile_page.dart';
import 'info_page.dart';

const Color kPrimaryColor = Color(0xFF7B4BFF);
const Color kPrimaryLightColor = Color(0xFFE6E0FF);

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
  static const String login = '/';
  static const String home = '/home';
  static const String messages = '/messages';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String privacy = '/privacy';
  static const String aboutUs = '/aboutUs';

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
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = _routesMap[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    return _errorRoute(settings.name);
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder:
          (context) => Scaffold(
            appBar: AppBar(title: const Text("Error de Navegación")),
            body: Center(child: Text('Ruta no definida: $routeName')),
          ),
    );
  }
}
