import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize(BuildContext context) async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    }

    // Get token and send to backend
    String? token = await _messaging.getToken();
    if (token != null) {
      await ApiService.updateDeviceToken(1, token);  // User ID 1 mock; replace with real
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message.notification!.title ?? 'Alert'),
            content: Text(message.notification!.body ?? 'Threat detected!'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
          ),
        );
      }
    });

    // Background/terminated app open from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navigate to relevant screen, e.g., analytics
      Navigator.push(context, MaterialPageRoute(builder: (_) => AnalyticsScreen()));
    });

    // Handle initial message if app opened from notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      // Handle
    }
  }
}