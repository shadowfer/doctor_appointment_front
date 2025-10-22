import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

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

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.displayName ?? user?.email ?? 'Usuario';
    if (displayName.contains('@')) {
      displayName = displayName.split('@')[0];
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.3),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: kPrimaryLightColor,
                  child: Icon(Icons.person, size: 32, color: kPrimaryColor),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, $displayName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Gestiona tu perfil y configuración',
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildSettingsTile(
            context,
            icon: Icons.person_outline,
            title: 'Perfil',
            onTap: () {
              Navigator.pushNamed(context, Routes.profile);
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.lock_outline,
            title: 'Privacidad',
            onTap: () {
              Navigator.pushNamed(context, Routes.privacy);
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'Sobre Nosotros',
            onTap: () {
              Navigator.pushNamed(context, Routes.aboutUs);
            },
          ),
          const SizedBox(height: 20),
          const Divider(indent: 20, endIndent: 20),
          const SizedBox(height: 20),

          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: 'Cerrar Sesión',
            color: Colors.red.shade700,
            onTap: () {
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final tileColor = color ?? Colors.black87;
    return ListTile(
      leading: Icon(icon, color: tileColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          color: tileColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[400],
        size: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      onTap: onTap,
    );
  }
}
