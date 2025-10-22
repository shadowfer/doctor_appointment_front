import 'package:flutter/material.dart';
import 'routes.dart';

// --- CONSTANTES DE COLOR ---
// Asumimos que estas constantes se definen en routes.dart (o están disponibles aquí)
const Color kCorporatePrimaryColor = Color(0xFF005691); // Azul Oscuro
const Color kCorporateAccentColor = Color(0xFF14B8A6); // Teal/Cyan

class _MessageData {
  final String name;
  final String message;
  final String time;
  final bool isUnread;
  final IconData avatarIcon;
  final Color avatarColor;

  _MessageData({
    required this.name,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.avatarIcon,
    required this.avatarColor,
  });
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de datos de ejemplo (se mantiene)
    final List<_MessageData> messages = [
      _MessageData(
        name: 'Dr. Elara Vance',
        message: 'Recuerda tomar tus medicamentos.',
        time: '1:45 PM',
        isUnread: true,
        avatarIcon: Icons.favorite_border,
        avatarColor: Colors.pink,
      ),
      _MessageData(
        name: 'Clínica Piel Sana',
        message: 'Tu cita ha sido confirmada para...',
        time: '11:30 AM',
        isUnread: false,
        avatarIcon: Icons.healing_outlined,
        avatarColor: Colors.deepOrange,
      ),
      _MessageData(
        name: 'Dr. Kenji Tanaka',
        message: 'Los resultados de tu biopsia están listos.',
        time: 'Ayer',
        isUnread: true,
        avatarIcon: Icons.person_search,
        avatarColor: Colors.blueGrey,
      ),
      _MessageData(
        name: 'Dra. Sofia Reyes',
        message: '¿Cómo ha evolucionado la tos?',
        time: 'Ayer',
        isUnread: false,
        avatarIcon: Icons.child_care_outlined,
        avatarColor: Colors.blue,
      ),
      _MessageData(
        name: 'Dr. Marcus Chen',
        message: 'Perfecto, nos vemos en la consulta virtual.',
        time: '2d atrás',
        isUnread: false,
        avatarIcon: Icons.psychology_outlined,
        avatarColor: Colors.purple,
      ),
      _MessageData(
        name: 'Soporte DoctorApp',
        message: 'Bienvenido a nuestro servicio de mensajería.',
        time: '2d atrás',
        isUnread: false,
        avatarIcon: Icons.support_agent,
        avatarColor: Colors.green,
      ),
    ];

    return Scaffold(
      // Fondo gris claro consistente (como el body del HTML)
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // AppBar blanco y limpio (simula el header del HTML)
        title: const Text(
          'Mensajes',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22, // Tamaño de texto 2xl del HTML
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1, // Sombra sutil (border-b)
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey[700]), // Ícono gris
            onPressed: () {},
          ),
          // Puedes añadir el icono de nuevo mensaje si lo deseas aquí, o dejarlo solo búsqueda.
        ],
      ),
      body: Center(
        child: Container(
          // Contenedor blanco para la lista (simula el div principal del HTML)
          constraints: const BoxConstraints(maxWidth: 800),
          decoration: BoxDecoration(
            color: Colors.white,
            // Sombra solo si es visible en pantallas grandes (desktop/tablet)
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: ListView.separated(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              return _buildMessageTile(context, msg);
            },
            // Separador muy fino (divide-y divide-gray-100)
            separatorBuilder:
                (context, index) => Divider(
                  height: 1,
                  indent: 80,
                  endIndent: 20,
                  color: Colors.grey.shade100,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTile(BuildContext context, _MessageData data) {
    return Container(
      // Fondo sutil para mensajes no leídos (simula bg-teal-50)
      color:
          data.isUnread
              ? kCorporateAccentColor.withOpacity(0.03)
              : Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Acción de navegación a la conversación
          },
          highlightColor: Colors.grey.withOpacity(0.05), // hover:bg-gray-50
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ), // Más padding horizontal
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- AVATAR ---
                Container(
                  width: 48, // w-12
                  height: 48, // h-12
                  decoration: BoxDecoration(
                    color: data.avatarColor.withOpacity(
                      0.1,
                    ), // Fondo color de la especialidad claro
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Icon(
                      data.avatarIcon,
                      size: 24,
                      color: data.avatarColor,
                    ),
                  ),
                  margin: const EdgeInsets.only(right: 16),
                ),

                // --- CONTENIDO DEL TEXTO ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: TextStyle(
                          // Título del chat en negrita si no está leído, y en azul corporativo
                          fontWeight:
                              data.isUnread ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                          color:
                              data.isUnread
                                  ? kCorporatePrimaryColor
                                  : Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          // Último mensaje en negrita si no está leído, color gris sutil si está leído
                          fontWeight:
                              data.isUnread
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                          color:
                              data.isUnread ? Colors.black87 : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- HORA E INDICADOR NO LEÍDO ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.time,
                      style: TextStyle(
                        fontSize: 12,
                        // Hora en color de acento si hay mensajes no leídos
                        color:
                            data.isUnread
                                ? kCorporateAccentColor
                                : Colors.grey[500],
                        fontWeight:
                            data.isUnread ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (data.isUnread)
                      // Punto indicador (w-2 h-2 bg-teal-500)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: kCorporateAccentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
