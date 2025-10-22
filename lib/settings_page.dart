import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

// --- CONSTANTES DE COLOR (Asegúrate de que existan) ---
const Color kCorporatePrimaryColor = Color(0xFF005691); // Azul Oscuro
const Color kCorporateAccentColor = Color(0xFF14B8A6); // Teal/Cyan

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: ${e.toString()}')),
      );
    }
  }

  // Nuevo widget auxiliar para los encabezados de sección
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey[500],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Nuevo widget auxiliar para los elementos de la lista (simula la opción 'a' del HTML)
  Widget _buildListTileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = kCorporatePrimaryColor, // Por defecto, color principal
    Color textColor = Colors.black87,
    Color hoverColor = Colors.grey,
    Color? tileColor, // Para el fondo de "Cerrar Sesión"
  }) {
    return Container(
      color:
          tileColor, // Establece el color de fondo si existe (para Cerrar Sesión)
      child: Material(
        color: tileColor ?? Colors.transparent, // Fondo de Material
        child: InkWell(
          onTap: onTap,
          highlightColor: hoverColor.withOpacity(
            0.1,
          ), // Simula el hover:bg-gray-50
          splashColor: hoverColor.withOpacity(0.15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: 24),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: hoverColor.withOpacity(
                    0.5,
                  ), // Color más sutil para la flecha
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.displayName ?? user?.email ?? 'Usuario';
    if (displayName.contains('@')) {
      displayName = displayName.split('@')[0];
    }
    final String initials =
        displayName.isNotEmpty
            ? displayName
                .trim()
                .split(' ')
                .map((l) => l.isNotEmpty ? l[0] : '')
                .join('')
                .toUpperCase()
            : '?';

    return Scaffold(
      // Fondo gris claro (bg-gray-100)
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // Encabezado blanco, solo muestra el título
        title: const Text(
          'Configuración',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1, // Borde inferior simulado
        shadowColor: Colors.grey.withOpacity(0.3),
        automaticallyImplyLeading: false, // Ocultar el botón de retroceso
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECCIÓN DE BIENVENIDA Y RESUMEN DE PERFIL
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: Row(
                children: [
                  Container(
                    width: 64, // w-16
                    height: 64, // h-16
                    // Avatar Teal/Cyan (como el ejemplo HTML)
                    decoration: BoxDecoration(
                      color: kCorporateAccentColor,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials.length > 2
                            ? initials.substring(0, 2)
                            : initials, // Muestra hasta 2 iniciales
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, $displayName', // Nombre más grande (text-xl font-semibold)
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Gestiona tu perfil y configuración de la aplicación.', // Texto gris (text-sm text-gray-500)
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- SEPARADOR TIPO BARRA GRIS ---
            Container(
              height: 10,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),

            // --- OPCIONES DEL PERFIL (Grupo 1: Mi Cuenta) ---
            _buildSectionHeader('Mi Cuenta'),
            _buildListTileOption(
              context: context,
              icon: Icons.person_outline,
              title: 'Mi Perfil',
              iconColor: kCorporatePrimaryColor, // Icono en azul corporativo
              hoverColor: kCorporateAccentColor, // Hover en Teal/Cyan
              onTap: () => Navigator.pushNamed(context, Routes.profile),
            ),
            _buildListTileOption(
              context: context,
              icon: Icons.lock_outline,
              title: 'Privacidad y Seguridad',
              iconColor: kCorporatePrimaryColor,
              hoverColor: kCorporateAccentColor,
              onTap: () => Navigator.pushNamed(context, Routes.privacy),
            ),
            _buildListTileOption(
              context: context,
              icon: Icons.notifications_none_outlined,
              title: 'Notificaciones',
              iconColor: kCorporatePrimaryColor,
              hoverColor: kCorporateAccentColor,
              onTap: () {
                // Notificaciones no tiene una ruta en routes.dart, así que lo simulamos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Abriendo ajustes de Notificaciones...'),
                  ),
                );
              },
            ),

            // --- SEPARADOR TIPO BARRA GRIS ---
            Container(
              height: 10,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),

            // --- OPCIONES GENERALES (Grupo 2: Soporte y Legal) ---
            _buildSectionHeader('Soporte y Legal'),
            _buildListTileOption(
              context: context,
              icon: Icons.support_agent_outlined,
              title: 'Ayuda y Soporte',
              iconColor: kCorporatePrimaryColor,
              hoverColor: kCorporateAccentColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abriendo Ayuda y Soporte...')),
                );
              },
            ),
            _buildListTileOption(
              context: context,
              icon: Icons.info_outline,
              title: 'Sobre MediLink',
              iconColor: kCorporatePrimaryColor,
              hoverColor: kCorporateAccentColor,
              onTap: () => Navigator.pushNamed(context, Routes.aboutUs),
            ),

            // --- SEPARADOR TIPO BARRA GRIS ---
            Container(
              height: 10,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),

            // --- Opción CERRAR SESIÓN (Resaltado en Rojo) ---
            _buildListTileOption(
              context: context,
              icon: Icons.logout,
              title: 'Cerrar Sesión',
              iconColor: Colors.red.shade700,
              textColor: Colors.red.shade700,
              tileColor: Colors.red.shade50, // Fondo rojo claro (bg-red-50)
              hoverColor: Colors.red,
              onTap: () {
                _signOut(context);
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
