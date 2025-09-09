import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _flnp =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Timezone initialization
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flnp.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {
        // You can parse payload here to deep-link later.
      },
    );

    if (Platform.isAndroid) {
      // Android 13+ runtime permission
      await _flnp
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      // Create a default channel for reminders
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'reminders',
        'Reminders',
        description: 'Task and payment reminder notifications',
        importance: Importance.high,
      );

      await _flnp
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
    _initialized = true;
  }

  Future<void> scheduleTaskReminder({
    required int id,
    required String title,
    required DateTime when,
    String? payload,
  }) async {
    if (!_initialized) await init();

    // Not supported on web/desktop for zonedSchedule
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    final now = DateTime.now();
    if (when.isBefore(now)) return;

    final tz.TZDateTime tzWhen = tz.TZDateTime.from(when, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'Task and payment reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flnp.zonedSchedule(
      id,
      'Task Reminder',
      title,
      tzWhen,
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  Future<void> schedulePaymentReminder({
    required int id,
    required String title,
    required DateTime when,
    String? payload,
  }) async {
    if (!_initialized) await init();

    // Not supported on web/desktop for zonedSchedule
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return;
    }

    final now = DateTime.now();
    if (when.isBefore(now)) return; // don't schedule past notifications

    final tz.TZDateTime tzWhen = tz.TZDateTime.from(when, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'reminders',
      'Reminders',
      channelDescription: 'Task and payment reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flnp.zonedSchedule(
      id,
      'Payment Reminder',
      title,
      tzWhen,
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  Future<void> cancel(int id) async {
    if (!_initialized) await init();
    await _flnp.cancel(id);
  }

  Future<void> cancelAll() async {
    if (!_initialized) await init();
    await _flnp.cancelAll();
  }
}
