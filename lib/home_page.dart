import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'routes.dart'; // Make sure routes.dart exists and defines the color constants
import 'messages_page.dart';
import 'settings_page.dart';
import 'citas_page.dart'; // Import CitasPage

// --- COLOR CONSTANTS ---
// Ensure these constants are available, typically defined in routes.dart
const Color kCorporatePrimaryColor = Color(0xFF005691); // Dark Blue
const Color kCorporateAccentColor = Color(0xFF14B8A6); // Teal/Cyan

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages for the BottomNavigationBar
  static final List<Widget> _pages = <Widget>[
    const _HomeContent(), // The main content widget for the Home tab
    const CitasPage(), // Placeholder or actual CitasPage
    const MessagesPage(), // Placeholder or actual MessagesPage
    const SettingsPage(), // Placeholder or actual SettingsPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The main background color for the entire page scaffold
      backgroundColor: Colors.grey.shade100, // bg-gray-100 equivalent
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // BOTTOM NAVIGATION BAR (styled according to the HTML footer)
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // Home (Active on this page)
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Use filled icon when active
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
            // Using CircleAvatar for the profile icon background when selected
            icon: CircleAvatar(
              radius: 14,
              backgroundColor:
                  _selectedIndex == 3
                      ? kCorporateAccentColor
                      : Colors.transparent,
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
        selectedItemColor:
            kCorporateAccentColor, // Active item color is Teal/Cyan
        unselectedItemColor: Colors.grey[600], // Inactive item color
        onTap: _onItemTapped, // Handles tab switching
        backgroundColor: Colors.white, // Footer background
        elevation: 8, // Shadow effect
        type: BottomNavigationBarType.fixed, // All items visible
        showUnselectedLabels: true, // Show labels for inactive items
        selectedFontSize: 12, // Font size for active label
        unselectedFontSize: 12, // Font size for inactive labels
      ),
    );
  }
}

// --- Content for the Home Tab (_HomeContent) ---
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  // Helper Widget for Quick Action Cards
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color iconBgColor, // Background color for the icon circle
    required Color iconColor, // Color of the icon itself
    required VoidCallback onTap,
  }) {
    return Container(
      // Card styling: white background, border, rounded corners, shadow
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade200,
        ), // border border-gray-200
        borderRadius: BorderRadius.circular(12), // rounded-xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // shadow-lg (approx)
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        // Using Material for InkWell effect
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          // Simulates hover effect (e.g., hover:bg-teal-50)
          highlightColor: iconBgColor.withOpacity(0.5),
          splashColor: iconBgColor.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // p-4
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // items-center
              children: [
                // Icon container: circular background
                Container(
                  width: 48,
                  height: 48, // w-12 h-12
                  decoration: BoxDecoration(
                    color: iconBgColor, // e.g., bg-teal-100
                    shape: BoxShape.circle, // rounded-full
                  ),
                  child: Icon(icon, size: 24, color: iconColor), // Icon styling
                ),
                const SizedBox(height: 8), // mb-2
                // Title text
                Text(
                  title,
                  textAlign: TextAlign.center, // text-center
                  style: const TextStyle(
                    fontWeight: FontWeight.w500, // font-medium
                    fontSize: 14, // text-sm
                    color: Colors.black87, // text-gray-800 (approx)
                  ),
                  maxLines: 2, // Allow up to 2 lines
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis if text overflows
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for Specialty Tags (Chips)
  Widget _buildSpecialistChips() {
    // Data for the chips
    const specialists = [
      {
        'name': 'Cardiología',
        'icon': Icons.favorite_border,
        'color': Color(0xFFE91E63),
      }, // Pink
      {
        'name': 'Dermatología',
        'icon': Icons.healing_outlined,
        'color': Color(0xFFF57C00),
      }, // Orange
      {
        'name': 'Pediatría',
        'icon': Icons.child_care_outlined,
        'color': Color(0xFF1976D2),
      }, // Blue
      {
        'name': 'Neurología',
        'icon': Icons.psychology_outlined,
        'color': Color(0xFF9C27B0),
      }, // Purple
      {
        'name': 'Ginecología',
        'icon': Icons.pregnant_woman_outlined,
        'color': Color(0xFFC62828),
      }, // Red
      {
        'name': 'Oftalmología',
        'icon': Icons.visibility_outlined,
        'color': kCorporateAccentColor,
      }, // Teal
    ];

    // Using Wrap to display chips that flow to the next line if needed
    return Wrap(
      spacing: 8.0, // gap-2 horizontal spacing
      runSpacing: 8.0, // gap-2 vertical spacing
      children:
          specialists.map((spec) {
            final Color color = spec['color'] as Color;
            return Chip(
              // Icon before the text
              avatar: Icon(spec['icon'] as IconData, color: color, size: 16),
              label: Text(spec['name'] as String),
              // Styling the chip background and text color based on specialty
              backgroundColor: color.withOpacity(0.1), // e.g., bg-pink-100
              elevation: 0,
              side: BorderSide.none, // No border
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ), // px-3 py-1
              labelStyle: TextStyle(
                color: color.withOpacity(0.9), // e.g., text-pink-700
                fontWeight: FontWeight.w600, // font-medium (approx)
                fontSize: 12,
              ), // text-xs
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ), // rounded-full
            );
          }).toList(),
    );
  }

  // Helper Widget for Doctor Cards
  Widget _buildDoctorCard(
    BuildContext context,
    String name,
    String specialty,
    double rating,
    String imagePath, // Local asset path or network URL
    String hospital,
    String availability,
    int reviews,
    int experience,
  ) {
    bool isNetworkImage = imagePath.startsWith('http');
    bool hasImagePath = imagePath.isNotEmpty;

    return Card(
      elevation: 4, // shadow-lg
      shadowColor: Colors.black.withOpacity(0.1), // Adjusted shadow color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // rounded-xl
      margin: const EdgeInsets.only(bottom: 12), // mb-3
      child: InkWell(
        // Make the card tappable
        onTap: () {
          /* TODO: Navigate to doctor details */
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // p-4
          child: Column(
            children: [
              // Top section: Avatar and basic info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Avatar
                  Container(
                    width: 64,
                    height: 64, // w-16 h-16
                    decoration: BoxDecoration(
                      color: kCorporatePrimaryColor, // Fallback background
                      shape: BoxShape.circle, // rounded-full
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ], // shadow-md
                      image:
                          hasImagePath
                              ? DecorationImage(
                                image:
                                    isNetworkImage
                                        ? NetworkImage(imagePath)
                                        : AssetImage(imagePath)
                                            as ImageProvider,
                                fit: BoxFit.cover, // object-cover
                              )
                              : null,
                    ),
                    // Placeholder text if no image
                    child:
                        !hasImagePath
                            ? const Center(
                              child: Text(
                                'Dr',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : null,
                  ),
                  const SizedBox(width: 16), // space-x-4
                  // Doctor details (Name, Specialty, Location, Time)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Doctor Name
                            Flexible(
                              // Prevents overflow with long names
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16, // text-base
                                  fontWeight: FontWeight.w600, // font-semibold
                                  color: kCorporatePrimaryColor, // text-primary
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Rating display
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                              ), // Add padding to prevent touching name
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber.shade500,
                                    size: 16,
                                  ), // Star icon
                                  const SizedBox(width: 4),
                                  Text(
                                    rating.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ), // Rating number
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Specialty
                        Text(
                          specialty,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ), // text-sm text-gray-600
                        ),
                        const SizedBox(height: 8), // mt-1
                        // Location and Availability Row
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                hospital,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ), // text-xs text-gray-500
                            const SizedBox(width: 10),
                            Icon(
                              Icons.access_time_outlined,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                availability,
                                style: TextStyle(
                                  fontSize: 12,
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
                ],
              ),
              // Bottom section: Reviews, Experience, and Schedule Button
              Padding(
                padding: const EdgeInsets.only(top: 8.0), // pt-2 mt-2
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey.shade200,
                      height: 16,
                    ), // border-t
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Reviews and Experience Text
                        Text(
                          '$reviews reseñas • $experience años exp.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ), // text-xs text-gray-500
                        ),
                        // Schedule Button
                        TextButton.icon(
                          onPressed: () {
                            /* TODO: Schedule action */
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: kCorporateAccentColor,
                          ), // Arrow icon
                          label: const Text(
                            'Agendar',
                            style: TextStyle(
                              fontWeight: FontWeight.w600, // font-semibold
                              fontSize: 14, // text-sm
                              color: kCorporateAccentColor, // text-teal-600
                            ),
                          ),
                          // Minimal padding for button
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero, // Remove default min size
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // Reduce tap area
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
    // Fetch user data (replace with actual data fetching if needed)
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? user?.email ?? 'Usuario';
    // Get first name for greeting
    final String welcomeName =
        displayName.split(' ').isNotEmpty
            ? displayName.split(' ')[0]
            : 'Usuario';
    // Get initials for avatar
    final String initials =
        displayName.isNotEmpty
            ? displayName
                .trim()
                .split(' ')
                .map((l) => l.isNotEmpty ? l[0] : '')
                .take(2)
                .join('')
                .toUpperCase()
            : '?';

    // Using Container allows setting the background color that the SingleChildScrollView scrolls over
    return Container(
      color:
          Colors.grey.shade100, // Main background color for the scrollable area
      child: SingleChildScrollView(
        // Makes the content scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- HEADER SECTION (Replaces AppBar) ---
            Container(
              // *** CORRECTION IS HERE ***
              // Remove the 'color' property if it exists outside 'decoration'
              // color: Colors.white, // REMOVE THIS LINE IF PRESENT
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 16,
              ), // Adjusted padding
              // Use 'decoration' to set color and border
              decoration: BoxDecoration(
                color: Colors.white, // Set color INSIDE decoration
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ), // border-b border-gray-100
              ),
              // *** END CORRECTION ***
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Greeting Text Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido de vuelta',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ), // text-sm font-medium text-gray-500
                      ),
                      Text(
                        '¡Hola, $welcomeName!', // Display only first name
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800, // font-extrabold approx
                          color: kCorporatePrimaryColor,
                        ), // text-xl text-primary
                      ),
                    ],
                  ),
                  // User Avatar
                  Container(
                    width: 40,
                    height: 40, // w-10 h-10
                    decoration: BoxDecoration(
                      color: kCorporateAccentColor, // bg-teal-500
                      shape: BoxShape.circle, // rounded-full
                      boxShadow: [
                        // shadow-md
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials.length > 2
                            ? initials.substring(0, 2)
                            : initials, // Limit to 2 initials
                        style: const TextStyle(
                          fontSize: 14, // text-sm
                          fontWeight: FontWeight.w600, // font-semibold
                          color: Colors.white,
                        ), // text-white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // --- SEARCH BAR SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15,
              ), // p-4
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar especialistas, síntomas...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ), // Icon inside
                  filled: true,
                  fillColor: Colors.white, // White background
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 15,
                  ), // py-3 pl-12 approx
                  // Border styling
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // rounded-xl
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ), // border border-gray-300
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  // Focus border styling
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: kCorporateAccentColor,
                      width: 2,
                    ), // focus:ring-2 focus:ring-teal-500
                  ),
                ),
              ),
            ),

            // --- QUICK ACTIONS SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ), // p-4
              child: GridView.count(
                crossAxisCount: 2, // grid-cols-2
                shrinkWrap:
                    true, // Important for GridView inside ListView/Column
                physics:
                    const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                crossAxisSpacing: 16, // gap-4
                mainAxisSpacing: 16, // gap-4
                childAspectRatio: 1.2, // Adjust aspect ratio for card shape
                children: [
                  _buildActionCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'Agendar Cita',
                    iconBgColor: kCorporateAccentColor.withOpacity(
                      0.1,
                    ), // bg-teal-100
                    iconColor: kCorporateAccentColor, // text-teal-600
                    onTap: () {
                      /* TODO: Navigate to Schedule Appointment */
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.lightbulb_outline,
                    title: 'Consejos Médicos',
                    iconBgColor: Colors.amber.shade100, // bg-yellow-100
                    iconColor: Colors.amber.shade600, // text-yellow-600
                    onTap: () {
                      /* TODO: Navigate to Medical Tips */
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Mis Recetas',
                    iconBgColor: Colors.pink.shade100, // bg-pink-100
                    iconColor: Colors.pink.shade600, // text-pink-600
                    onTap: () {
                      /* TODO: Navigate to Prescriptions */
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.video_camera_front_outlined,
                    title: 'Consulta Virtual',
                    iconBgColor: Colors.purple.shade100, // bg-purple-100
                    iconColor: Colors.purple.shade600, // text-purple-600
                    onTap: () {
                      /* TODO: Navigate to Virtual Consultation */
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Space between sections
            // --- SPECIALTIES SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // p-4
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Especialidades',
                        style: TextStyle(
                          fontSize: 18, // text-lg
                          fontWeight: FontWeight.bold, // font-bold
                          color: Colors.black87,
                        ), // text-gray-900 approx
                      ),
                      TextButton(
                        onPressed: () {
                          /* TODO: Navigate to All Specialties */
                        },
                        child: const Text(
                          'Ver todas',
                          style: TextStyle(
                            color: kCorporateAccentColor, // text-teal-600
                            fontWeight: FontWeight.w600, // font-semibold
                            fontSize: 14,
                          ), // text-sm
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12), // mb-3
                  // Chips/Tags
                  _buildSpecialistChips(),
                ],
              ),
            ),
            const SizedBox(height: 20), // Extra space
            // --- POPULAR DOCTORS SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0), // p-4
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Doctores Populares',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          /* TODO: Navigate to All Doctors */
                        },
                        child: const Text(
                          'Ver todos',
                          style: TextStyle(
                            color: kCorporateAccentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12), // mb-3
                  // List of Doctor Cards
                  _buildDoctorCard(
                    context,
                    'Dr. Elara Vance',
                    'Cardióloga',
                    4.9,
                    'assets/images/doctora.jpg', // LOCAL IMAGE PATH
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
                    'assets/images/drkenji.jpg', // LOCAL IMAGE PATH
                    'Clínica Piel Sana',
                    'Lun, 28 Oct',
                    98,
                    8,
                  ),
                  const SizedBox(height: 40), // Final spacing at the bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
