import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

// --- CONSTANTES DE COLOR ---
// Asumimos que estas constantes se definen en routes.dart (o están disponibles aquí)
const Color kCorporatePrimaryColor = Color(0xFF005691); // Azul Oscuro
const Color kCorporateAccentColor = Color(0xFF14B8A6); // Teal/Cyan

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  // --- CONTROLADORES DE DATOS PERSISTENTES ---
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _enfermedadesController = TextEditingController();
  final _emailController = TextEditingController(); // Email (read-only)

  // NUEVOS CONTROLADORES A PERSISTIR
  final _fechaNacimientoController = TextEditingController();
  final _tipoSangreController = TextEditingController();
  final _alergiasController = TextEditingController();
  final _nombreEmergenciaController = TextEditingController();
  final _telefonoEmergenciaController = TextEditingController();

  bool _loading = true;
  // ------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _enfermedadesController.dispose();
    _emailController.dispose();
    _fechaNacimientoController.dispose();
    _tipoSangreController.dispose();
    _alergiasController.dispose();
    _nombreEmergenciaController.dispose();
    _telefonoEmergenciaController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE CARGA DE DATOS ---
  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _emailController.text = user.email ?? 'N/A';

    try {
      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        _nombreController.text = data['nombre'] ?? user.displayName ?? '';
        _telefonoController.text = data['telefono'] ?? '';
        _enfermedadesController.text = data['enfermedades'] ?? '';

        // Carga de datos de los nuevos campos
        _fechaNacimientoController.text = data['fechaNacimiento'] ?? '';
        _tipoSangreController.text = data['tipoSangre'] ?? '';
        _alergiasController.text = data['alergias'] ?? '';
        _nombreEmergenciaController.text = data['nombreEmergencia'] ?? '';
        _telefonoEmergenciaController.text = data['telefonoEmergencia'] ?? '';
      } else {
        _nombreController.text = user.displayName ?? '';
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

  // --- LÓGICA DE GUARDADO DE DATOS (CON TODOS LOS CAMPOS) ---
  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;
    final user = _auth.currentUser;
    if (user == null) return;

    if (!mounted) return;
    setState(() => _loading = true);

    try {
      final newName = _nombreController.text.trim();

      // CREACIÓN DEL MAPA DE DATOS CON TODOS LOS CAMPOS
      await _firestore.collection('usuarios').doc(user.uid).set({
        // Datos de Contacto y Perfil Base
        'nombre': newName,
        'telefono': _telefonoController.text.trim(),
        'email': user.email,

        // Datos Médicos
        'enfermedades': _enfermedadesController.text.trim(),
        'fechaNacimiento': _fechaNacimientoController.text.trim(),
        'tipoSangre': _tipoSangreController.text.trim(),
        'alergias': _alergiasController.text.trim(),

        // Datos de Emergencia
        'nombreEmergencia': _nombreEmergenciaController.text.trim(),
        'telefonoEmergencia': _telefonoEmergenciaController.text.trim(),
      }, SetOptions(merge: true));

      if (user.displayName != newName) {
        await user.updateDisplayName(newName);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado con éxito'),
          backgroundColor: Colors.green,
        ),
      );
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

  // --- Widget Auxiliar para los Campos de Texto (Estilo Corporativo) ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          style: TextStyle(color: readOnly ? Colors.grey[600] : Colors.black87),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 0),
              child: Icon(
                icon,
                color: readOnly ? Colors.grey[400] : kCorporateAccentColor,
                size: 20,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 20,
            ),

            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade50 : Colors.white,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: kCorporateAccentColor,
                width: 2.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget auxiliar para los encabezados de sección ---
  Widget _buildSectionDivider(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kCorporatePrimaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 1,
                color: kCorporateAccentColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String initialName = _nombreController.text.trim();
    final String initials =
        initialName.isNotEmpty
            ? initialName
                .trim()
                .split(' ')
                .map((l) => l.isNotEmpty ? l[0] : '')
                .join('')
                .toUpperCase()
            : 'FF';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Editar Perfil Médico",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.3),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body:
          _loading
              ? const Center(
                child: CircularProgressIndicator(color: kCorporateAccentColor),
              )
              : Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(25.0),
                      children: [
                        // --- SECCIÓN: AVATAR Y CAMBIAR FOTO ---
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: kCorporateAccentColor,
                                  borderRadius: BorderRadius.circular(48),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
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
                                        : initials,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Abriendo selector de imágenes...',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Cambiar foto de perfil',
                                  style: TextStyle(
                                    color: kCorporateAccentColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // --- SECCIÓN 1: DATOS PERSONALES Y DE CONTACTO ---
                        _buildSectionDivider('Datos Personales y de Contacto'),
                        _buildTextField(
                          controller: _nombreController,
                          label: 'Nombre Completo',
                          icon: Icons.person_outline,
                          validator:
                              (val) =>
                                  val!.isEmpty
                                      ? 'Por favor, ingrese su nombre'
                                      : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Correo Electrónico (No modificable)',
                          icon: Icons.mail_outline,
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _fechaNacimientoController,
                          label: 'Fecha de Nacimiento',
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.datetime,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _telefonoController,
                          label: 'Número de Teléfono',
                          icon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 30),

                        // --- SECCIÓN 2: INFORMACIÓN MÉDICA ---
                        _buildSectionDivider('Información Médica'),
                        _buildTextField(
                          controller: _tipoSangreController,
                          label: 'Tipo de Sangre',
                          icon: Icons.bloodtype_outlined,
                          // Se podría usar un DropdownButton aquí en lugar de un TextField
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _alergiasController,
                          label: 'Alergias (si aplica)',
                          icon: Icons.healing_outlined,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _enfermedadesController,
                          label: 'Padecimientos Crónicos o Actuales',
                          icon: Icons.medical_services_outlined,
                          maxLines: 4,
                        ),

                        const SizedBox(height: 30),

                        // --- SECCIÓN 3: CONTACTO DE EMERGENCIA ---
                        _buildSectionDivider('Contacto de Emergencia'),
                        _buildTextField(
                          controller: _nombreEmergenciaController,
                          label: 'Nombre del Contacto',
                          icon: Icons.emergency_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _telefonoEmergenciaController,
                          label: 'Teléfono del Contacto',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 40),

                        // --- BOTÓN GUARDAR CAMBIOS ---
                        ElevatedButton(
                          onPressed: _loading ? null : _saveUserData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kCorporatePrimaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                          ),
                          child:
                              _loading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                  : const Text('GUARDAR CAMBIOS'),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
