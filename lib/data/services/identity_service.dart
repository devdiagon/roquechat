import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../nombres_usuarios.dart';

class IdentityService {
  static const _keyUsername = 'username';

  Future<String> getOrCreateUsername() async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getString(_keyUsername);
    if (existing != null) {
      return existing;
    }

    final random = Random();
    final username = nombresUsuarios[random.nextInt(nombresUsuarios.length)];

    await prefs.setString(_keyUsername, username);
    return username;
  }
}