// lib/crear_cita_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as DateTimePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart'; // For color constants
import 'models/cita_model.dart';
import 'services/firestore_service.dart';

// --- COLOR CONSTANTS ---
const Color kCorporatePrimaryColor = Color(0xFF005691);
const Color kCorporateAccentColor = Color(0xFF14B8A6);

class CrearCitaPage extends StatefulWidget {
  const CrearCitaPage({super.key});

  @override
  State<CrearCitaPage> createState() => _CrearCitaPageState();
}

class _CrearCitaPageState extends State<CrearCitaPage> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime? _fechaHoraInicioSeleccionada;
  DateTime? _fechaHoraFinSeleccionada;
  final _motivoController = TextEditingController();
  Map<String, String>? _medicoSeleccionado;

  List<Map<String, String>> _listaDoctores = [];
  bool _isLoadingDoctores = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _cargarDoctores();
  }

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _cargarDoctores() async {
    try {
      final doctores = await _firestoreService.getDoctores();
      if (mounted) {
        setState(() {
          _listaDoctores = doctores;
          _isLoadingDoctores = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar doctores: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoadingDoctores = false);
      }
    }
  }

  void _seleccionarFechaHora({required bool esInicio}) {
    DateTimePicker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 90)),
      onConfirm: (date) {
        setState(() {
          if (esInicio) {
            _fechaHoraInicioSeleccionada = date;
            if (_fechaHoraFinSeleccionada == null ||
                _fechaHoraFinSeleccionada!.isBefore(date)) {
              _fechaHoraFinSeleccionada = date.add(const Duration(hours: 1));
            }
          } else {
            _fechaHoraFinSeleccionada = date;
          }
        });
      },
      currentTime:
          esInicio
              ? (_fechaHoraInicioSeleccionada ?? DateTime.now())
              : (_fechaHoraFinSeleccionada ??
                  DateTime.now().add(const Duration(hours: 1))),
      locale: DateTimePicker.LocaleType.es,
    );
  }

  Future<void> _guardarCita() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaHoraInicioSeleccionada == null ||
        _fechaHoraFinSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar fecha y hora de inicio y fin'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_fechaHoraFinSeleccionada!.isBefore(_fechaHoraInicioSeleccionada!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La hora de fin no puede ser anterior a la hora de inicio',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_medicoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar un médico'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // --- Overlap Validation ---
      bool haySuperposicion = await _firestoreService.checkOverlap(
        medicoId: _medicoSeleccionado!['id']!,
        nuevaFechaHoraInicio: _fechaHoraInicioSeleccionada!,
        nuevaFechaHoraFin: _fechaHoraFinSeleccionada!,
      );

      if (haySuperposicion) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'El horario seleccionado ya está ocupado. Por favor, elige otro.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isSaving = false);
        return;
      }
      // --- End Overlap Validation ---

      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception("Usuario no autenticado.");

      final nuevaCita = Cita(
        pacienteId: userId,
        medicoId: _medicoSeleccionado!['id']!,
        nombreMedico: _medicoSeleccionado!['nombre']!,
        fechaHoraInicio: _fechaHoraInicioSeleccionada!,
        fechaHoraFin: _fechaHoraFinSeleccionada!,
        motivo: _motivoController.text.trim(),
      );

      await _firestoreService.addCita(nuevaCita);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita creada con éxito'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la cita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatoFecha = DateFormat('EEE, d MMM yyyy', 'es_ES');
    final formatoHora = DateFormat('hh:mm a');

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Agendar Nueva Cita',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kCorporatePrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body:
          _isLoadingDoctores
              ? const Center(
                child: CircularProgressIndicator(color: kCorporateAccentColor),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionHeader('Selecciona al Médico'),
                      DropdownButtonFormField<Map<String, String>>(
                        value: _medicoSeleccionado,
                        hint: const Text('Elige un doctor'),
                        items:
                            _listaDoctores.map((medico) {
                              return DropdownMenuItem<Map<String, String>>(
                                value: medico,
                                child: Text(medico['nombre']!),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _medicoSeleccionado = value;
                          });
                        },
                        decoration: _inputDecoration(
                          'Médico',
                          Icons.person_search_outlined,
                        ),
                        validator:
                            (value) =>
                                value == null ? 'Selecciona un médico' : null,
                      ),
                      const SizedBox(height: 20),

                      _buildSectionHeader('Fecha y Hora'),
                      ListTile(
                        leading: const Icon(
                          Icons.calendar_today_outlined,
                          color: kCorporateAccentColor,
                        ),
                        title: const Text('Inicio de la Cita'),
                        subtitle: Text(
                          _fechaHoraInicioSeleccionada == null
                              ? 'No seleccionada'
                              : '${formatoFecha.format(_fechaHoraInicioSeleccionada!)} ${formatoHora.format(_fechaHoraInicioSeleccionada!)}',
                        ),
                        trailing: const Icon(Icons.edit_calendar_outlined),
                        onTap: () => _seleccionarFechaHora(esInicio: true),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(
                          Icons.watch_later_outlined,
                          color: kCorporateAccentColor,
                        ),
                        title: const Text('Fin de la Cita'),
                        subtitle: Text(
                          _fechaHoraFinSeleccionada == null
                              ? 'No seleccionada'
                              : '${formatoFecha.format(_fechaHoraFinSeleccionada!)} ${formatoHora.format(_fechaHoraFinSeleccionada!)}',
                        ),
                        trailing: const Icon(Icons.edit_calendar_outlined),
                        onTap: () => _seleccionarFechaHora(esInicio: false),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildSectionHeader('Detalles de la Cita'),
                      TextFormField(
                        controller: _motivoController,
                        decoration: _inputDecoration(
                          'Motivo de la Consulta',
                          Icons.notes_outlined,
                        ).copyWith(
                          hintText: 'Ej: Revisión general, Dolor de cabeza...',
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa el motivo de la cita';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _guardarCita,
                        icon:
                            _isSaving
                                ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                : const Icon(Icons.save_alt_outlined),
                        label: Text(
                          _isSaving ? 'Guardando...' : 'Confirmar Cita',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kCorporateAccentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  // Helper para la decoración
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      prefixIcon: Icon(icon, color: kCorporateAccentColor, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kCorporateAccentColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }

  // Helper para los encabezados de sección
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: kCorporatePrimaryColor,
        ),
      ),
    );
  }
}
