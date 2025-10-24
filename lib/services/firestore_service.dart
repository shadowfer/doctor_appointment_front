// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cita_model.dart'; // Ensure the path to cita_model.dart is correct

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Operaciones CRUD para Citas ---

  // Obtener Stream de Citas para el usuario actual
  Stream<List<Cita>> getCitasUsuario() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]); // Return empty stream if no user
    }

    return _db
        .collection('citas')
        .where('pacienteId', isEqualTo: userId)
        .orderBy('fechaHoraInicio', descending: false) // Order by start date
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Cita.fromFirestore(doc)).toList(),
        );
  }

  // Crear una nueva cita
  Future<void> addCita(Cita cita) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not authenticated.");
    }

    // Ensure the cita object has the correct patientId
    final citaConUserId = Cita(
      pacienteId: userId,
      medicoId: cita.medicoId,
      nombreMedico: cita.nombreMedico,
      fechaHoraInicio: cita.fechaHoraInicio,
      fechaHoraFin: cita.fechaHoraFin,
      motivo: cita.motivo,
      // createdAt will be handled by FieldValue.serverTimestamp() in toFirestore
    );

    return _db.collection('citas').add(citaConUserId.toFirestore());
  }

  // Actualizar una cita existente
  Future<void> updateCita(Cita cita) {
    if (cita.id == null) {
      throw Exception("Appointment ID cannot be null for update.");
    }
    // Update using the existing ID and ensure createdAt is not overwritten if it exists
    Map<String, dynamic> dataToUpdate = cita.toFirestore();
    dataToUpdate.remove('createdAt'); // Don't update createdAt
    return _db.collection('citas').doc(cita.id).update(dataToUpdate);
  }

  // Eliminar una cita
  Future<void> deleteCita(String citaId) {
    return _db.collection('citas').doc(citaId).delete();
  }

  // --- Validación de Superposición ---
  Future<bool> checkOverlap({
    required String medicoId,
    required DateTime nuevaFechaHoraInicio,
    required DateTime nuevaFechaHoraFin,
    String?
    citaIdExcluida, // ID of the appointment being edited (to exclude it from the check)
  }) async {
    final Timestamp inicioTimestamp = Timestamp.fromDate(nuevaFechaHoraInicio);
    final Timestamp finTimestamp = Timestamp.fromDate(nuevaFechaHoraFin);

    // Base query: Appointments for the same doctor
    Query query = _db
        .collection('citas')
        .where('medicoId', isEqualTo: medicoId);

    // Overlap condition:
    // An existing appointment (E) overlaps with the new one (N) if:
    // (E.StartTime < N.EndTime) AND (E.EndTime > N.StartTime)
    query = query
        .where('fechaHoraInicio', isLessThan: finTimestamp)
        .where('fechaHoraFin', isGreaterThan: inicioTimestamp);

    // If editing, exclude the current appointment from the check
    if (citaIdExcluida != null) {
      query = query.where(FieldPath.documentId, isNotEqualTo: citaIdExcluida);
    }

    final querySnapshot = await query.limit(1).get();

    // If the query returns any documents, there is an overlap
    return querySnapshot.docs.isNotEmpty;
  }

  // --- Método para obtener doctores (simplificado) ---
  Future<List<Map<String, String>>> getDoctores() async {
    // In a real app, this would come from a 'doctors' collection
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
    return [
      {'id': 'doc1', 'nombre': 'Dr. Elara Vance'},
      {'id': 'doc2', 'nombre': 'Dr. Kenji Tanaka'},
      {'id': 'doc3', 'nombre': 'Dra. Sofia Reyes'},
    ];
  }
}
