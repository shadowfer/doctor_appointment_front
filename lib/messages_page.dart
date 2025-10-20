import 'package:flutter/material.dart';
import 'routes.dart'; // Para kPrimaryColor y kPrimaryLightColor

class MessagesPage extends StatelessWidget {
  // Se añade 'const' para asegurar la compatibilidad con las rutas.
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mensajes',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.3),
        automaticallyImplyLeading: false, // Ocultar la flecha de "atrás"
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 8, // UI de ejemplo
        itemBuilder: (context, index) {
          final bool isUnread = index % 3 == 0;
          return _buildMessageTile(
            context,
            'Dr. Nombre Apellido',
            'Hola, ¿cómo sigues de la consulta?...',
            '12:30 PM',
            isUnread,
          );
        },
        separatorBuilder:
            (context, index) =>
                const Divider(height: 1, indent: 80, endIndent: 20),
      ),
    );
  }

  // Widget para construir cada fila de la lista de mensajes
  Widget _buildMessageTile(
    BuildContext context,
    String name,
    String msg,
    String time,
    bool isUnread,
  ) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 28,
        backgroundColor: kPrimaryLightColor,
        child: Icon(Icons.person, size: 30, color: kPrimaryColor),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        msg,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isUnread ? Colors.black87 : Colors.grey[600],
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isUnread ? kPrimaryColor : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 5),
          if (isUnread)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      onTap: () {},
    );
  }
}
