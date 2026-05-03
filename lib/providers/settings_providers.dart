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
