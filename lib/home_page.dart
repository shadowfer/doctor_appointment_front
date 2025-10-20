import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Importamos tus páginas y el archivo de rutas para los colores
import 'routes.dart';
import 'messages_page.dart';
import 'settings_page.dart';

/// HomePage: El contenedor principal con la barra de navegación.
/// Tu estructura original se mantiene, ya que es ideal para manejar las pestañas.
class HomePage extends StatefulWidget {
  // Lo convertimos en const ya que no recibe parámetros.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Lista de las páginas principales que se mostrarán en cada pestaña.
  // MessagesPage y SettingsPage se crearán en los siguientes pasos.
  static final List<Widget> _pages = <Widget>[
    const _HomeContent(), // Pestaña 0: Contenido de Inicio
    const MessagesPage(), // Pestaña 1: Mensajes
    SettingsPage(), // Pestaña 2: Configuración
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Un fondo suave para toda la app
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Mensajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor, // Usando el color de routes.dart
        unselectedItemColor: Colors.grey[500],
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 8,
        type:
            BottomNavigationBarType
                .fixed, // Asegura que todos los items se vean
      ),
    );
  }
}

/// _HomeContent: El contenido visual de la pestaña de Inicio.
/// Se ha rediseñado para ser más limpio y moderno.
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Un saludo más amigable, usando el nombre de perfil si existe, o el email.
    final String displayName = user?.displayName ?? user?.email ?? 'Usuario';
    final String welcomeName =
        displayName.contains('@') ? displayName.split('@')[0] : displayName;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // --- Mensaje de Bienvenida ---
          Text(
            '¡Hola, $welcomeName!',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            '¿En qué podemos ayudarte?',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 25),

          // --- Widgets de Acción (Requerimiento 2) ---
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.calendar_month,
                  title: 'Agendar Cita',
                  color: kPrimaryColor,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.lightbulb_outline,
                  title: 'Consejos Médicos',
                  color: Colors.orange.shade700,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // --- Lista de Especialistas (Requerimiento 2) ---
          const Text(
            'Especialistas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          _buildSpecialistChips(),
          const SizedBox(height: 30),

          // --- Doctores Populares (Mantenido y mejorado) ---
          const Text(
            'Doctores Populares',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          _buildDoctorCard('Dr. Elara Vance', 'Cardióloga', 4.9),
          _buildDoctorCard('Dr. Kenji Tanaka', 'Dermatólogo', 4.8),
        ],
      ),
    );
  }

  // --- Widgets de construcción de UI (rediseñados) ---

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialistChips() {
    const specialists = [
      'Cardiología',
      'Dermatología',
      'Pediatría',
      'Neurología',
      'Ginecología',
      'Oftalmología',
    ];
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children:
          specialists
              .map(
                (spec) => Chip(
                  label: Text(spec),
                  backgroundColor: kPrimaryLightColor,
                  elevation: 0,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  labelStyle: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildDoctorCard(String name, String specialty, double rating) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: kPrimaryLightColor,
              child: const Icon(Icons.person, size: 30, color: kPrimaryColor),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  color: Colors.amber.shade600,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
