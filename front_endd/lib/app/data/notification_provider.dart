import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationProvider extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 🔹 Remplace XX par ton IP (ipconfig dans terminal Windows)
  static const String baseUrl = "http://192.168.1.11:5000";

  Future<NotificationProvider> init() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permission status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      
      try {
        String? token = await _messaging.getToken();
        print("FCM TOKEN: $token");

        // 🔹 Envoie automatique au backend
        if (token != null) {
          await _sendTokenToBackend(token);
        }

        // 🔹 Si token se renouvelle automatiquement
        _messaging.onTokenRefresh.listen((newToken) {
          _sendTokenToBackend(newToken);
        });

      } catch (e) {
        print("Erreur getToken: $e");
      }
    } else {
      print("Permission refusée — token non disponible");
    }

    FirebaseMessaging.onMessage.listen((message) {
      Get.snackbar(
        message.notification?.title ?? "Notification",
        message.notification?.body ?? "",
      );
    });

    return this;
  }

  // 🔹 Fonction d'envoi du token au backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register-token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );
      print("Token envoyé: ${response.statusCode}");
    } catch (e) {
      print("Erreur envoi token: $e");
    }
  }
}