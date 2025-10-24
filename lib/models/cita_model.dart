// lib/models/cita_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Cita {
  final String? id; // ID del documento en Firestore
  final String pacienteId; // ID del usuario (paciente)
  final String medicoId; // ID o nombre del médico
  final String nombreMedico; // Nombre del médico para mostrar
  final DateTime fechaHoraInicio;
  final DateTime fechaHoraFin;
  final String motivo;
  final Timestamp? createdAt; // Para ordenar o filtrar por fecha de creación

  Cita({
    this.id,
    required this.pacienteId,
    required this.medicoId,
    required this.nombreMedico,
    required this.fechaHoraInicio,
    required this.fechaHoraFin,
    required this.motivo,
    this.createdAt,
  });

  // Método para convertir un DocumentSnapshot de Firestore a un objeto Cita
  factory Cita.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cita(
      id: doc.id,
      pacienteId: data['pacienteId'] ?? '',
      medicoId: data['medicoId'] ?? '',
      nombreMedico: data['nombreMedico'] ?? 'Médico Desconocido',
      fechaHoraInicio: (data['fechaHoraInicio'] as Timestamp).toDate(),
      fechaHoraFin: (data['fechaHoraFin'] as Timestamp).toDate(),
      motivo: data['motivo'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  // Método para convertir un objeto Cita a un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'pacienteId': pacienteId,
      'medicoId': medicoId,
      'nombreMedico': nombreMedico,
      'fechaHoraInicio': Timestamp.fromDate(fechaHoraInicio),
      'fechaHoraFin': Timestamp.fromDate(fechaHoraFin),
      'motivo': motivo,
      // Usamos FieldValue.serverTimestamp() solo al crear para que Firestore ponga la hora
      'createdAt': createdAt ?? FieldValue.serverTimestamp(), 
    };
  }
}