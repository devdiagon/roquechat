import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _messaging.requestPermission();

    String? token = await getToken();
    /* DEBUG ONLY - REMOVE LATTER*/
    if (token != null) {
      debugPrint("FCM Token: $token");
    }
  }

  Future<String?> getToken() async {
    try {
      String? token = await _messaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }
}