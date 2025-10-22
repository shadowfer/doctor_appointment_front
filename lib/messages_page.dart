import 'package:flutter/material.dart';
import 'routes.dart';

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
      appBar: AppBar(
        title: const Text('Mensajes', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return _buildMessageTile(context, msg);
        },
        separatorBuilder:
            (context, index) =>
                const Divider(height: 1, indent: 80, endIndent: 20),
      ),
    );
  }

  Widget _buildMessageTile(BuildContext context, _MessageData data) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: data.avatarColor.withOpacity(0.15),
        child: Icon(data.avatarIcon, size: 30, color: data.avatarColor),
      ),
      title: Text(
        data.name,
        style: TextStyle(
          fontWeight: data.isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        data.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: data.isUnread ? Colors.black87 : Colors.grey[600],
          fontWeight: data.isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            data.time,
            style: TextStyle(
              fontSize: 12,
              color: data.isUnread ? kPrimaryColor : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 5),
          if (data.isUnread)
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
