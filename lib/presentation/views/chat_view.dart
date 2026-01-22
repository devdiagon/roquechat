import 'package:fireldb/presentation/providers/identity_provider.dart';
import 'package:fireldb/presentation/widgets/msg_bar.dart';
import 'package:fireldb/presentation/widgets/msg_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';

class ChatView extends ConsumerStatefulWidget  {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    data: (mensajes) {
                      _scrollToBottom();

                      return ListView.builder(
                        controller: scrollController,
                        reverse: true,
                        itemCount: mensajes.length,
                        itemBuilder: (_, i) {
                          final m = mensajes[mensajes.length -1 - i];
                          return MsgBox(mensaje: m, esPropio: m.autor == usuario);
                        },
                      );
                    },
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
