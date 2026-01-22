import 'package:fireldb/presentation/providers/identity_provider.dart';
import 'package:fireldb/presentation/widgets/msg_bar.dart';
import 'package:fireldb/presentation/widgets/msg_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';

class ChatView extends ConsumerWidget {
  ChatView({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajesAsync = ref.watch(mensajesProvider);
    final usuarioAsync = ref.watch(usernameProvider);
    final service = ref.read(firebaseServiceProvider);

    return usuarioAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (usuario) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Chat – $usuario'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: mensajesAsync.when(
                  data: (mensajes) => ListView.builder(
                    reverse: true,
                    itemCount: mensajes.length,
                    itemBuilder: (_, i) {
                      final m = mensajes[mensajes.length -1 - i];
                      return MsgBox(mensaje: m, esPropio: m.autor == usuario);
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),

              MsgBar(controller: controller, usuario: usuario, service: service),
            ],
          ),
        );
      }
    );
  }
}
