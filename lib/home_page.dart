import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'messages_page.dart';
import 'settings_page.dart';

// Placeholder para CitasPage si aún no la tienes
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

  static final List<Widget> _pages = <Widget>[
    const _HomeContent(),
    const CitasPage(),
    const MessagesPage(),
    const SettingsPage(), // <-- CAMBIO AQUÍ: Ahora muestra la página de configuración
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Citas',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Mensajes',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor:
                  _selectedIndex == 3 ? Colors.black87 : Colors.transparent,
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
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 8,
        type:
            BottomNavigationBarType
                .fixed, // Asegura que todos los items se muestren
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }
}

// --- Contenido de la pestaña Inicio ---
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? user?.email ?? 'Usuario';
    final String welcomeName = displayName;
    final String initials =
        displayName.isNotEmpty
            ? displayName
                .trim()
                .split(' ')
                .map((l) => l.isNotEmpty ? l[0] : '')
                .take(2)
                .join()
                .toUpperCase()
            : '?';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido de vuelta',
              style: TextStyle(fontSize: 12, color: kPrimaryLightColor),
            ),
            Text(
              '¡Hola, $welcomeName!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: kPrimaryColor,
              radius: 18,
              child: Text(
                initials,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              /* Acción notificación */
            },
          ),
        ],
        toolbarHeight: 70,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar especialistas, síntomas...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: kPrimaryColor),
              ),
            ),
          ),
          const SizedBox(height: 25),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.9,
            children: [
              _buildActionCard(
                icon: Icons.calendar_today_outlined,
                title: 'Agendar Cita',
                color: Colors.white,
                iconBgColor: kPrimaryLightColor,
                iconColor: kPrimaryColor,
                onTap: () {},
              ),
              _buildActionCard(
                icon: Icons.lightbulb_outline,
                title: 'Consejos Médicos',
                color: Colors.white,
                iconBgColor: Colors.orange.shade100,
                iconColor: Colors.orange.shade800,
                onTap: () {},
              ),
              _buildActionCard(
                icon: Icons.receipt_long_outlined,
                title: 'Mis Recetas',
                color: Colors.white,
                iconBgColor: Colors.green.shade100,
                iconColor: Colors.green.shade800,
                onTap: () {},
              ),
              _buildActionCard(
                icon: Icons.video_camera_front_outlined,
                title: 'Consulta Virtual',
                color: Colors.white,
                iconBgColor: Colors.purple.shade100,
                iconColor: Colors.purple.shade800,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Especialidades',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Ver todas',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildSpecialistChips(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Doctores Populares',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Ver todos',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDoctorCard(
            context,
            'Dr. Elara Vance',
            'Cardióloga',
            4.9,
            'assets/images/doctora.jpg',
            'Hospital Central',
            'Hoy, 3:00 PM',
            127,
            12,
          ),
          _buildDoctorCard(
            context,
            'Dr. Kenji Tanaka',
            'Dermatólogo',
            4.8,
            'assets/images/drkenji.jpg',
            'Clínica Piel Sana',
            'Mañana, 10:00 AM',
            98,
            8,
          ),
          // Añade más doctores si es necesario
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: iconBgColor,
                child: Icon(icon, size: 28, color: iconColor),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
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

  Widget _buildSpecialistChips() {
    const specialists = [
      {
        'name': 'Cardiología',
        'icon': Icons.favorite_border,
        'color': Colors.pink,
      },
      {
        'name': 'Dermatología',
        'icon': Icons.healing_outlined,
        'color': Colors.deepOrange,
      },
      {
        'name': 'Pediatría',
        'icon': Icons.child_care_outlined,
        'color': Colors.blue,
      },
      {
        'name': 'Neurología',
        'icon': Icons.psychology_outlined,
        'color': Colors.purple,
      },
      {
        'name': 'Ginecología',
        'icon': Icons.pregnant_woman_outlined,
        'color': Colors.red,
      },
      {
        'name': 'Oftalmología',
        'icon': Icons.visibility_outlined,
        'color': Colors.teal,
      },
    ];

    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children:
          specialists.map((spec) {
            final Color color = spec['color'] as Color;
            return Chip(
              avatar: Icon(spec['icon'] as IconData, color: color, size: 18),
              label: Text(spec['name'] as String),
              backgroundColor: color.withOpacity(0.1),
              elevation: 0,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
            );
          }).toList(),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context,
    String name,
    String specialty,
    double rating,
    String imagePath,
    String hospital,
    String availability,
    int reviews,
    int experience,
  ) {
    bool isNetworkImage = imagePath.startsWith('http');
    bool hasImagePath = imagePath.isNotEmpty;

    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: kPrimaryLightColor,
                  backgroundImage:
                      hasImagePath
                          ? (isNetworkImage
                              ? NetworkImage(imagePath)
                              : AssetImage(imagePath) as ImageProvider)
                          : null,
                  onBackgroundImageError:
                      hasImagePath
                          ? (exception, stackTrace) {
                            print(
                              'Error cargando imagen ($imagePath): $exception',
                            );
                          }
                          : null,
                  child:
                      !hasImagePath // Mostrar icono solo si no hay imagePath
                          ? const Icon(
                            Icons.person,
                            size: 40,
                            color: kPrimaryColor,
                          )
                          : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              hospital,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.access_time_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              availability,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$reviews reseñas • $experience años exp.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                InkWell(
                  onTap: () {
                    /* Acción Agendar Cita */
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Agendar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16, color: kPrimaryColor),
                    ],
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
