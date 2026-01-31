import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../constants/const_keys.dart';


@lazySingleton
class LocalNotificationManager {
  final FlutterLocalNotificationsPlugin _localNotification;
  final StreamController<String?> _onNotificationClick =
      StreamController<String?>.broadcast();

  Stream<String?> get onNotificationClick => _onNotificationClick.stream;

  LocalNotificationManager(this._localNotification);

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotification.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap
    );
  }

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
          ConstKeys.channelId,
          ConstKeys.channelName,
          channelDescription: ConstKeys.channelDesc,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    final DarwinNotificationDetails iosDetails =
        const DarwinNotificationDetails(presentSound: true);

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.show(id: id, title: title, body: body, notificationDetails: details, payload: payload);
  }

  Future<void> cancel(int id) async {
    await _localNotification.cancel(id: id);
  }

  Future<void> cancelAll() async {
    await _localNotification.cancelAll();
  }

  void _onNotificationTap(NotificationResponse details) {
    if (details.payload != null) {
      _onNotificationClick.add(details.payload);
    }
  }
}
