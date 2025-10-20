import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'routes.dart'; // Importamos para usar kPrimaryColor

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mantenemos tu lógica de controladores y referencias a Firebase.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>(); // Clave para validar el formulario
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _enfermedadesController = TextEditingController();

  bool _loading = true; // Inicia en true para mostrar carga al abrir

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    // Limpiamos los controladores para liberar memoria.
    _nombreController.dispose();
    _telefonoController.dispose();
    _enfermedadesController.dispose();
    super.dispose();
  }

  // Tu lógica para cargar datos, ligeramente ajustada para el manejo de estado.
  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        _nombreController.text = data['nombre'] ?? '';
        _telefonoController.text = data['telefono'] ?? '';
        _enfermedadesController.text = data['enfermedades'] ?? '';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Tu lógica para guardar datos, integrada con el rediseño y validación.
  Future<void> _saveUserData() async {
    // Primero, validamos que el formulario cumpla las reglas (ej. nombre no vacío)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    if (!mounted) return;
    setState(() => _loading = true);

    try {
      // Guardamos los datos en Firestore.
      await _firestore.collection('usuarios').doc(user.uid).set({
        'nombre': _nombreController.text.trim(),
        'telefono': _telefonoController.text.trim(),
        'enfermedades': _enfermedadesController.text.trim(),
        'email': user.email,
      }, SetOptions(merge: true));

      // Actualizamos también el nombre de perfil de Firebase Auth
      if (user.displayName != _nombreController.text.trim()) {
        await user.updateDisplayName(_nombreController.text.trim());
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Volvemos a la pantalla de Configuración
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: kPrimaryColor,
        elevation: 2,
      ),
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              )
              : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    _buildTextField(
                      controller: _nombreController,
                      label: 'Nombre Completo',
                      icon: Icons.person,
                      validator:
                          (val) =>
                              val!.isEmpty
                                  ? 'Por favor, ingrese su nombre'
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _telefonoController,
                      label: 'Número de Teléfono',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _enfermedadesController,
                      label: 'Padecimientos (opcional)',
                      icon: Icons.medical_services_outlined,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Guardar Cambios'),
                    ),
                  ],
                ),
              ),
    );
  }

  /// Widget reutilizable para crear campos de texto con nuestro estilo.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kPrimaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
      ),
    );
  }
}
