import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'messages_page.dart';
import 'settings_page.dart';

// --- CONSTANTES DE COLOR ---
// Aseguramos que estas constantes estén disponibles.
const Color kCorporatePrimaryColor = Color(0xFF005691); // Azul Oscuro
const Color kCorporateAccentColor = Color(0xFF14B8A6); // Teal/Cyan

// Placeholder para CitasPage
class CitasPage extends StatelessWidget {
  const CitasPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Página de Citas (Placeholder)'));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Las páginas se mantienen para la navegación inferior
  static final List<Widget> _pages = <Widget>[
    const _HomeContent(),
    const CitasPage(),
    const MessagesPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El fondo gris claro se establece aquí para toda la página,
      // pero el fondo blanco del _HomeContent lo simula.
      backgroundColor: Colors.grey.shade100, 
      body: IndexedStack(index: _selectedIndex, children: _pages),
      
      // BARRA DE NAVEGACIÓN INFERIOR (adaptado del footer HTML)
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // Inicio (ACTIVO en esta página)
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          // Citas
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Citas',
          ),
          // Mensajes
          const BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Mensajes',
          ),
          // Perfil
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor:
                  _selectedIndex == 3 ? kCorporateAccentColor : Colors.transparent,
              child: Icon(
                Icons.person_outline,
                color: _selectedIndex == 3 ? Colors.white : Colors.grey[600],
                size: 18,
              ),
            ),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        // El color activo es el Teal/Cyan
        selectedItemColor: kCorporateAccentColor, 
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }
}

// --- Contenido de la pestaña Inicio (_HomeContent) ---
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  // Widget Auxiliar para las Tarjetas de Acción
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200), // border border-gray-200
        borderRadius: BorderRadius.circular(12), // rounded-xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // shadow-lg
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        highlightColor: iconBgColor.withOpacity(0.5), 
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48, height: 48, // w-12 h-12
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, size: 24, color: iconColor),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Auxiliar para las Etiquetas de Especialidad
  Widget _buildSpecialistChips() {
    const specialists = [
      {'name': 'Cardiología', 'icon': Icons.favorite_border, 'color': Color(0xFFE91E63)}, // Pink
      {'name': 'Dermatología', 'icon': Icons.healing_outlined, 'color': Color(0xFFF57C00)}, // Orange
      {'name': 'Pediatría', 'icon': Icons.child_care_outlined, 'color': Color(0xFF1976D2)}, // Blue
      {'name': 'Neurología', 'icon': Icons.psychology_outlined, 'color': Color(0xFF9C27B0)}, // Purple
      {'name': 'Ginecología', 'icon': Icons.pregnant_woman_outlined, 'color': Color(0xFFC62828)}, // Red
      {'name': 'Oftalmología', 'icon': Icons.visibility_outlined, 'color': kCorporateAccentColor}, // Teal
    ];

    return Wrap(
      spacing: 8.0, // gap-2
      runSpacing: 8.0,
      children:
          specialists.map((spec) {
            final Color color = spec['color'] as Color;
            return Chip(
              avatar: Icon(spec['icon'] as IconData, color: color, size: 16),
              label: Text(spec['name'] as String),
              backgroundColor: color.withOpacity(0.1),
              elevation: 0,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
            );
          }).toList(),
    );
  }

  // Widget Auxiliar para la Tarjeta de Doctor (Adaptado al nuevo estilo)
  Widget _buildDoctorCard(
    BuildContext context,
    String name,
    String specialty,
    double rating,
    String imagePath, // Ruta de imagen (local o de red)
    String hospital,
    String availability,
    int reviews,
    int experience,
  ) {
    bool isNetworkImage = imagePath.startsWith('http');
    bool hasImagePath = imagePath.isNotEmpty;
    // Si la ruta es local, usaremos AssetImage.

    return Card(
      elevation: 4, // shadow-lg
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // rounded-xl
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {/* Navegación a detalle del doctor */},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar de Doctor
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: kCorporatePrimaryColor,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                      image: hasImagePath
                          ? DecorationImage(
                              image: isNetworkImage
                                  ? NetworkImage(imagePath)
                                  : AssetImage(imagePath) as ImageProvider, // Usa AssetImage para rutas locales
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: !hasImagePath
                        ? const Center(child: Text('Dr', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))
                        : null,
                  ),
                  const SizedBox(width: 16), // space-x-4
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kCorporatePrimaryColor, // text-primary
                              ),
                            ),
                            // Rating
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber.shade500, size: 16),
                                const SizedBox(width: 4),
                                Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          specialty,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        // Ubicación y Hora
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Flexible(child: Text(hospital, style: TextStyle(fontSize: 12, color: Colors.grey[700]), overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 10),
                            Icon(Icons.access_time_outlined, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Flexible(child: Text(availability, style: TextStyle(fontSize: 12, color: Colors.grey[700]), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Línea de Reseñas y Botón Agendar
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Divider(color: Colors.grey.shade200, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$reviews reseñas • $experience años exp.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward, size: 16, color: kCorporateAccentColor),
                          label: const Text(
                            'Agendar',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: kCorporateAccentColor, // Color de Acento
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simulamos la obtención de datos de usuario de Firebase
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? user?.email ?? 'Usuario';
    final String welcomeName = displayName.split(' ').isNotEmpty ? displayName.split(' ')[0] : 'Usuario';
    final String initials =
        displayName.isNotEmpty ? displayName.trim().split(' ').map((l) => l.isNotEmpty ? l[0] : '').join('').toUpperCase() : '?';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- HEADER / Encabezado y Saludo ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido de vuelta',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '¡Hola, $welcomeName!',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: kCorporatePrimaryColor), // text-primary
                    ),
                  ],
                ),
                // Avatar de Perfil
                Container(
                  width: 40, height: 40, // w-10 h-10
                  decoration: BoxDecoration(
                    color: kCorporateAccentColor, // bg-teal-500
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Center(
                    child: Text(
                      initials.length > 2 ? initials.substring(0, 2) : initials,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // --- BARRA DE BÚSQUEDA ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar especialistas, síntomas...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // rounded-xl
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kCorporateAccentColor, width: 2), // focus:ring-2 focus:ring-teal-500
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),

          // --- ACCIONES RÁPIDAS (Quick Actions) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16, // gap-4
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildActionCard(
                  icon: Icons.calendar_month_outlined,
                  title: 'Agendar Cita',
                  iconBgColor: kCorporateAccentColor.withOpacity(0.1),
                  iconColor: kCorporateAccentColor,
                  onTap: () {},
                ),
                _buildActionCard(
                  icon: Icons.lightbulb_outline,
                  title: 'Consejos Médicos',
                  iconBgColor: Colors.amber.shade100,
                  iconColor: Colors.amber.shade600,
                  onTap: () {},
                ),
                _buildActionCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Mis Recetas',
                  iconBgColor: Colors.pink.shade100,
                  iconColor: Colors.pink.shade600,
                  onTap: () {},
                ),
                _buildActionCard(
                  icon: Icons.video_camera_front_outlined,
                  title: 'Consulta Virtual',
                  iconBgColor: Colors.purple.shade100,
                  iconColor: Colors.purple.shade600,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // --- SECCIÓN DE ESPECIALIDADES ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Especialidades',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Ver todas',
                    style: TextStyle(color: kCorporateAccentColor, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: _buildSpecialistChips(),
          ),
          const SizedBox(height: 10),

          // --- SECCIÓN DE DOCTORES POPULARES ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Doctores Populares',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Ver todos',
                    style: TextStyle(color: kCorporateAccentColor, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: [
                // Doctor 1: Dr. Elara Vance - RUTA DE IMAGEN MANTENIDA
                _buildDoctorCard(
                  context, 
                  'Dr. Elara Vance', 
                  'Cardióloga', 
                  4.9, 
                  'assets/images/doctora.jpg', // <--- RUTA LOCAL
                  'Hospital Central', 
                  'Hoy, 3:00 PM', 
                  127, 
                  12
                ),
                // Doctor 2: Dr. Kenji Tanaka - RUTA DE IMAGEN MANTENIDA
                _buildDoctorCard(
                  context, 
                  'Dr. Kenji Tanaka', 
                  'Dermatólogo', 
                  4.8, 
                  'assets/images/drkenji.jpg', // <--- RUTA LOCAL
                  'Clínica Piel Sana', 
                  'Lun, 28 Oct', 
                  98, 
                  8
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}