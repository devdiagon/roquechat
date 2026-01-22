import 'package:firebase_database/firebase_database.dart';
import 'package:fireldb/domain/models/mensaje.dart';

class FirebaseService {
  // Instanciar Firebase -- ruta de la base de datos
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('chat/general');

  // Metodo para enviar mensajes
  Future<void> enviarMensaje(Mensaje mensaje) async {
    await _ref.push().set(mensaje.toJson());
  }

  // Metodo para recibir mensajes en tiempo real
  Stream<List<Mensaje>> recibirMensajes() {
    return _ref.onValue.map((event) {
      // obtener los datos
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      //no hay mensajes
      if (data == null) return [];

      // convertir el json en mensaje y enviarlo
      return data.values
          .map((e) => Mensaje.fromJson(e))
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
  }
}