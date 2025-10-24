// lib/citas_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesitas añadir 'intl' a tu pubspec.yaml
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';
import 'models/cita_model.dart'; // Asegúrate que la ruta sea correcta
import 'services/firestore_service.dart'; // Asegúrate que la ruta sea correcta

// Constantes de color
const Color kCorporatePrimaryColor = Color(0xFF005691);
const Color kCorporateAccentColor = Color(0xFF14B8A6);

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para mostrar el diálogo de confirmación de eliminación
  Future<void> _confirmarEliminacion(BuildContext context, Cita cita) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Cancelación'),
          content: Text('¿Estás seguro de que deseas cancelar la cita con ${cita.nombreMedico} el ${DateFormat('dd/MM/yyyy HH:mm').format(cita.fechaHoraInicio)}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // No confirmar
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sí, Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar
              },
            ),
          ],
        );
      },
    );

    if (confirmar == true && cita.id != null) {
      try {
        await _firestoreService.deleteCita(cita.id!);
        if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cita cancelada con éxito'), backgroundColor: Colors.green),
           );
        }
      } catch (e) {
         if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cancelar la cita: $e'), backgroundColor: Colors.red),
           );
         }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Mis Citas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kCorporatePrimaryColor,
        automaticallyImplyLeading: false,
        elevation: 4,
      ),
      body: StreamBuilder<List<Cita>>(
        stream: _firestoreService.getCitasUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kCorporateAccentColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar citas: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No tienes citas programadas.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final citas = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(15.0),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              final formatoFecha = DateFormat('EEE, d MMM yyyy', 'es_ES'); // Formato de fecha localizado
              final formatoHora = DateFormat('hh:mm a'); // Formato de hora AM/PM
              
              return Card(
                 elevation: 3,
                 shadowColor: Colors.grey.withOpacity(0.2),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    leading: CircleAvatar(
                      backgroundColor: kCorporateAccentColor.withOpacity(0.1),
                      child: const Icon(Icons.calendar_month_outlined, color: kCorporateAccentColor),
                    ),
                    title: Text(
                      'Cita con ${cita.nombreMedico}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kCorporatePrimaryColor),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('Fecha: ${formatoFecha.format(cita.fechaHoraInicio)}'),
                         Text('Hora: ${formatoHora.format(cita.fechaHoraInicio)} - ${formatoHora.format(cita.fechaHoraFin)}'),
                         if (cita.motivo.isNotEmpty) Text('Motivo: ${cita.motivo}', maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'editar') {
                            // Navegar a Editar (Paso 5) - Necesita pasar la cita
                            Navigator.pushNamed(context, '/editarCita', arguments: cita);
                          } else if (value == 'eliminar') {
                            // Eliminar con confirmación (Paso 6)
                             _confirmarEliminacion(context, cita);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'editar',
                            child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('Editar')),
                          ),
                          const PopupMenuItem<String>(
                            value: 'eliminar',
                            child: ListTile(leading: Icon(Icons.delete_outline, color: Colors.red), title: Text('Cancelar Cita', style: TextStyle(color: Colors.red))),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    onTap: () {
                      // Acción al tocar (puede ser navegar a editar directamente o a un detalle)
                      Navigator.pushNamed(context, '/editarCita', arguments: cita);
                    },
                 ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
      // Botón flotante para crear una nueva cita (Paso 4)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de creación
          Navigator.pushNamed(context, '/crearCita'); 
        },
        backgroundColor: kCorporateAccentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}