import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _channelId = 'cert_review';
  static const _reminderId = 42;
  static const _reviewId = 44;
  static const _dailyGoalId = 43;

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    } catch (_) {
      // Fallback to UTC if timezone data unavailable
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
  }

  static Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Cancels any existing review reminder and schedules a new one 3 days out.
  /// Call this after each quiz grade submission.
  static Future<void> rescheduleReminder() async {
    await _plugin.cancel(_reminderId);

    final scheduledDate =
        tz.TZDateTime.now(tz.local).add(const Duration(days: 3));

    await _plugin.zonedSchedule(
      _reminderId,
      '오늘도 자격증 공부해볼까요? 📚',
      '3일째 복습을 안 했어요. 잠깐이라도 문제를 풀어보세요!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          '복습 알림',
          channelDescription: '3일 미접속 시 복습 리마인더',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Schedules a review notification on [reviewDate] (SM-2 nextReview).
  /// Replaces any existing review notification.
  static Future<void> scheduleReviewNotification(DateTime reviewDate) async {
    await _plugin.cancel(_reviewId);
    final scheduledDate = tz.TZDateTime.from(reviewDate, tz.local);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      _reviewId,
      '복습할 시간이에요! 📖',
      '오늘 복습할 문제가 있어요. 지금 바로 시작해보세요!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          '복습 알림',
          channelDescription: 'SM-2 복습 일정 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Schedules a daily repeating notification at [hour]:[minute].
  /// Replaces any existing daily goal notification.
  static Future<void> scheduleDailyGoalNotification(
      int hour, int minute) async {
    await _plugin.cancel(_dailyGoalId);
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _dailyGoalId,
      '오늘의 자격증 공부 시간이에요! 🎯',
      '매일 꾸준히 하면 합격이 보여요.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          '복습 알림',
          channelDescription: '일일 목표 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelDailyGoalNotification() =>
      _plugin.cancel(_dailyGoalId);

  static Future<void> cancelAll() => _plugin.cancelAll();
}
