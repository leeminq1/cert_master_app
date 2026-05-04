import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import 'database_provider.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._db) : super(ThemeMode.system) {
    _load();
  }

  final AppDatabase _db;

  Future<void> _load() async {
    final val = await _db.settingsDao.get('theme_mode');
    if (val == 'light') {
      state = ThemeMode.light;
    } else if (val == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _db.settingsDao.set('theme_mode', mode.name);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(databaseProvider));
});

class NotificationEnabledNotifier extends StateNotifier<bool> {
  NotificationEnabledNotifier(this._db) : super(true) {
    _load();
  }

  final AppDatabase _db;

  Future<void> _load() async {
    final val = await _db.settingsDao.get('notification_enabled');
    state = val != 'false';
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _db.settingsDao.set('notification_enabled', enabled.toString());
  }
}

final notificationEnabledProvider =
    StateNotifierProvider<NotificationEnabledNotifier, bool>((ref) {
  return NotificationEnabledNotifier(ref.watch(databaseProvider));
});

class FontScaleNotifier extends StateNotifier<double> {
  FontScaleNotifier(this._db) : super(1.0) {
    _load();
  }

  final AppDatabase _db;

  Future<void> _load() async {
    final val = await _db.settingsDao.get('font_scale');
    if (val != null) state = double.tryParse(val) ?? 1.0;
  }

  Future<void> set(double v) async {
    state = v;
    await _db.settingsDao.set('font_scale', v.toStringAsFixed(2));
  }
}

final fontScaleProvider =
    StateNotifierProvider<FontScaleNotifier, double>((ref) {
  return FontScaleNotifier(ref.watch(databaseProvider));
});

class DailyGoalNotifier extends StateNotifier<int> {
  DailyGoalNotifier(this._db) : super(20) {
    _load();
  }

  final AppDatabase _db;

  Future<void> _load() async {
    final val = await _db.settingsDao.get('daily_goal');
    if (val != null) state = int.tryParse(val) ?? 20;
  }

  Future<void> set(int v) async {
    state = v;
    await _db.settingsDao.set('daily_goal', v.toString());
  }
}

final dailyGoalProvider =
    StateNotifierProvider<DailyGoalNotifier, int>((ref) {
  return DailyGoalNotifier(ref.watch(databaseProvider));
});
