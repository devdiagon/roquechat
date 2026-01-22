import 'package:flutter/material.dart';
import '../../domain/models/mensaje.dart';

class MsgBox extends StatelessWidget {
  final Mensaje mensaje;
  final bool esPropio;

  const MsgBox({super.key, required this.mensaje, required this.esPropio});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: esPropio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: esPropio ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mensaje.autor,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: esPropio ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mensaje.texto,
              style: TextStyle(
                color: esPropio ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
