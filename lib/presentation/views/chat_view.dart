import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../../domain/models/mensaje.dart';

class ChatView extends ConsumerWidget {
  ChatView({super.key});

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final String usuario = "Frederick";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajesAsync = ref.watch(mensajesProvider);
    final service = ref.read(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat en Tiempo Real'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //para  los mensajes
          Expanded(
            child: mensajesAsync.when(
              data: (mensajes) => ListView.builder(
                reverse: true,
                itemCount: mensajes.length,
                itemBuilder: (_, i) {
                  final m = mensajes[mensajes.length -1 - i];
                  return Align(
                    alignment: m.autor == usuario
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: m.autor == usuario ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.autor,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: m.autor == usuario ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.texto,
                            style: TextStyle(
                              color: m.autor == usuario ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error: $e')),
            ),
          ),

          //la barrita de mensaje
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (controller.text.trim().isEmpty) return;

                      service.enviarMensaje(
                        Mensaje(
                          texto: controller.text.trim(),
                          autor: usuario,
                          timestamp:
                          DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                      controller.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
