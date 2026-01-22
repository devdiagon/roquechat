import 'package:flutter/material.dart';
import '../../domain/models/mensaje.dart';
import '../../data/services/firebase_service.dart';

class MsgBar extends StatelessWidget {
  final TextEditingController controller;
  final String usuario;
  final FirebaseService service;

  const MsgBar({
    super.key,
    required this.controller,
    required this.usuario,
    required this.service
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}
