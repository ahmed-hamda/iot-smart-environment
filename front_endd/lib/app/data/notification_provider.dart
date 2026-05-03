import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationProvider extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<NotificationProvider> init() async {
    // 1. Demander les permissions et attendre le résultat
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permission status: ${settings.authorizationStatus}");

    // 2. Ne récupérer le token que si la permission est accordée
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      
      try {
        String? token = await _messaging.getToken();
        print("FCM TOKEN: $token");
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
}