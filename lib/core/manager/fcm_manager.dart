import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import 'local_notification_manager.dart';

@lazySingleton
class FcmManager {
  late final NotificationSettings _settings;
  final FirebaseMessaging _firebaseMessaging;
  final LocalNotificationManager _localNotificationManager;

  FcmManager(this._firebaseMessaging, this._localNotificationManager);

  Future<void> init() async {
    await requestPermission();

    await _localNotificationManager.init();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _setupForegroundListeners();
    _setupBackgroundClickListeners();
  }

  Future<NotificationSettings> requestPermission() async {
    _settings =  await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return _settings;
  }

  Future<String?> getDeviceToken() async {
    if (_settings.authorizationStatus == AuthorizationStatus.authorized) {
      return await _firebaseMessaging.getToken();
    }
    return null;
  }

  void _setupForegroundListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _localNotificationManager.showNotification(
          id: message.hashCode,
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data.toString(),
        );
      }
    });
  }

  void _setupBackgroundClickListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageNavigation);

    final RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageNavigation(initialMessage);
    }
  }

  void _handleMessageNavigation(RemoteMessage message) {

  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
}