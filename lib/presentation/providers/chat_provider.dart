import 'package:riverpod/riverpod.dart';
import 'package:fireldb/domain/models/mensaje.dart';
import 'package:fireldb/data/services/firebase_service.dart';

// Instancia de Firebase: accede a firebase desde cualquier parte de la app
final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

final mensajesProvider = StreamProvider<List<Mensaje>>((ref){
  final service = ref.read(firebaseServiceProvider);
  return service.recibirMensajes();
});