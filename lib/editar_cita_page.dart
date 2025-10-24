// lib/editar_cita_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as DateTimePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart'; // For colors
import 'models/cita_model.dart';
import 'services/firestore_service.dart';

// --- COLOR CONSTANTS ---
const Color kCorporatePrimaryColor = Color(0xFF005691);
const Color kCorporateAccentColor = Color(0xFF14B8A6);

class EditarCitaPage extends StatefulWidget {
  final Cita cita; // Receives the appointment to edit

  const EditarCitaPage({super.key, required this.cita});

  @override
  State<EditarCitaPage> createState() => _EditarCitaPageState();
}

class _EditarCitaPageState extends State<EditarCitaPage> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  late DateTime _fechaHoraInicioSeleccionada;
  late DateTime _fechaHoraFinSeleccionada;
  late TextEditingController _motivoController;
  Map<String, String>? _medicoSeleccionado;

  List<Map<String, String>> _listaDoctores = [];
  bool _isLoadingDoctores = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fechaHoraInicioSeleccionada = widget.cita.fechaHoraInicio;
    _fechaHoraFinSeleccionada = widget.cita.fechaHoraFin;
    _motivoController = TextEditingController(text: widget.cita.motivo);
    _medicoSeleccionado = {
      'id': widget.cita.medicoId,
      'nombre': widget.cita.nombreMedico,
    };
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
          _medicoSeleccionado = _listaDoctores.firstWhere(
            (doc) => doc['id'] == widget.cita.medicoId,
            orElse: () => _medicoSeleccionado!,
          );
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
      minTime: DateTime.now().subtract(const Duration(days: 30)),
      maxTime: DateTime.now().add(const Duration(days: 90)),
      onConfirm: (date) {
        setState(() {
          if (esInicio) {
            _fechaHoraInicioSeleccionada = date;
            if (_fechaHoraFinSeleccionada.isBefore(date)) {
              _fechaHoraFinSeleccionada = date.add(const Duration(hours: 1));
            }
          } else {
            _fechaHoraFinSeleccionada = date;
          }
        });
      },
      currentTime:
          esInicio ? _fechaHoraInicioSeleccionada : _fechaHoraFinSeleccionada,
      locale: DateTimePicker.LocaleType.es,
    );
  }

  Future<void> _actualizarCita() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaHoraFinSeleccionada.isBefore(_fechaHoraInicioSeleccionada)) {
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
    if (_medicoSeleccionado == null) return;

    setState(() => _isSaving = true);

    try {
      // --- Overlap Validation ---
      bool haySuperposicion = await _firestoreService.checkOverlap(
        medicoId: _medicoSeleccionado!['id']!,
        nuevaFechaHoraInicio: _fechaHoraInicioSeleccionada,
        nuevaFechaHoraFin: _fechaHoraFinSeleccionada,
        citaIdExcluida: widget.cita.id, // Pass the current appointment's ID
      );

      if (haySuperposicion) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'El nuevo horario se superpone con otra cita. Por favor, elige otro.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isSaving = false);
        return;
      }
      // --- End Overlap Validation ---

      final citaActualizada = Cita(
        id: widget.cita.id,
        pacienteId: widget.cita.pacienteId,
        medicoId: _medicoSeleccionado!['id']!,
        nombreMedico: _medicoSeleccionado!['nombre']!,
        fechaHoraInicio: _fechaHoraInicioSeleccionada,
        fechaHoraFin: _fechaHoraFinSeleccionada,
        motivo: _motivoController.text.trim(),
        createdAt: widget.cita.createdAt,
      );

      await _firestoreService.updateCita(citaActualizada);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita actualizada con éxito'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar la cita: $e'),
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
          'Editar Cita',
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
                      _buildSectionHeader('Médico Asignado'),
                      DropdownButtonFormField<Map<String, String>>(
                        value: _medicoSeleccionado,
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
                          '${formatoFecha.format(_fechaHoraInicioSeleccionada)} ${formatoHora.format(_fechaHoraInicioSeleccionada)}',
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
                          '${formatoFecha.format(_fechaHoraFinSeleccionada)} ${formatoHora.format(_fechaHoraFinSeleccionada)}',
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
                        validator:
                            (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? 'Ingresa el motivo'
                                    : null,
                      ),
                      const SizedBox(height: 30),

                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _actualizarCita,
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
                          _isSaving ? 'Guardando...' : 'Guardar Cambios',
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
