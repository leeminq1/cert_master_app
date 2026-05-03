import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_providers.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  TimeOfDay _dailyTime = const TimeOfDay(hour: 9, minute: 0);
  bool _dailyEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadDailyTime();
  }

  Future<void> _loadDailyTime() async {
    final db = ref.read(databaseProvider);
    final hour = await db.settingsDao.get('daily_hour');
    final minute = await db.settingsDao.get('daily_minute');
    final enabled = await db.settingsDao.get('daily_enabled');
    if (mounted) {
      setState(() {
        if (hour != null && minute != null) {
          _dailyTime = TimeOfDay(
            hour: int.tryParse(hour) ?? 9,
            minute: int.tryParse(minute) ?? 0,
          );
        }
        _dailyEnabled = enabled == 'true';
      });
    }
  }

  Future<void> _saveDailyTime(TimeOfDay time) async {
    final db = ref.read(databaseProvider);
    await db.settingsDao.set('daily_hour', time.hour.toString());
    await db.settingsDao.set('daily_minute', time.minute.toString());
    await NotificationService.scheduleDailyGoalNotification(
        time.hour, time.minute);
  }

  Future<void> _toggleDaily(bool value) async {
    final db = ref.read(databaseProvider);
    setState(() => _dailyEnabled = value);
    await db.settingsDao.set('daily_enabled', value.toString());
    if (value) {
      await NotificationService.scheduleDailyGoalNotification(
          _dailyTime.hour, _dailyTime.minute);
    } else {
      await NotificationService.cancelDailyGoalNotification();
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dailyTime,
    );
    if (picked == null || !mounted) return;
    setState(() => _dailyTime = picked);
    await _saveDailyTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;

    final themeMode = ref.watch(themeModeProvider);
    final notifEnabled = ref.watch(notificationEnabledProvider);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(
          '설정',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _SectionHeader(label: '테마', textDim: textDim),
          _SettingsCard(surface: surface, border: border, children: [
            _ThemeOption(
              label: '시스템',
              mode: ThemeMode.system,
              selected: themeMode == ThemeMode.system,
              lime: lime,
              text: text,
              onTap: () => ref
                  .read(themeModeProvider.notifier)
                  .setMode(ThemeMode.system),
            ),
            Divider(height: 1, color: border),
            _ThemeOption(
              label: '라이트',
              mode: ThemeMode.light,
              selected: themeMode == ThemeMode.light,
              lime: lime,
              text: text,
              onTap: () => ref
                  .read(themeModeProvider.notifier)
                  .setMode(ThemeMode.light),
            ),
            Divider(height: 1, color: border),
            _ThemeOption(
              label: '다크',
              mode: ThemeMode.dark,
              selected: themeMode == ThemeMode.dark,
              lime: lime,
              text: text,
              onTap: () =>
                  ref.read(themeModeProvider.notifier).setMode(ThemeMode.dark),
            ),
          ]),
          const SizedBox(height: 20),
          _SectionHeader(label: '알림', textDim: textDim),
          _SettingsCard(surface: surface, border: border, children: [
            _SwitchTile(
              label: '복습 알림',
              sublabel: '학습 후 3일 미접속 시 알림',
              value: notifEnabled,
              lime: lime,
              text: text,
              textDim: textDim,
              onChanged: (v) async {
                await ref
                    .read(notificationEnabledProvider.notifier)
                    .setEnabled(v);
                if (!v) await NotificationService.cancelAll();
              },
            ),
            Divider(height: 1, color: border),
            _SwitchTile(
              label: '매일 알림',
              sublabel: '매일 정해진 시간에 공부 알림',
              value: _dailyEnabled,
              lime: lime,
              text: text,
              textDim: textDim,
              onChanged: _toggleDaily,
            ),
            if (_dailyEnabled) ...[
              Divider(height: 1, color: border),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: Text(
                  '알림 시간',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: text),
                ),
                trailing: GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: lime.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: lime.withAlpha(80)),
                    ),
                    child: Text(
                      _dailyTime.format(context),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: lime,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ]),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color textDim;

  const _SectionHeader({required this.label, required this.textDim});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.notoSansKr(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textDim,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Color surface;
  final Color border;
  final List<Widget> children;

  const _SettingsCard(
      {required this.surface, required this.border, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final ThemeMode mode;
  final bool selected;
  final Color lime;
  final Color text;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.mode,
    required this.selected,
    required this.lime,
    required this.text,
    required this.onTap,
  });

  IconData get _icon {
    return switch (mode) {
      ThemeMode.system => Icons.brightness_auto,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(_icon, size: 18, color: selected ? lime : text),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.notoSansKr(
                fontSize: 14,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? lime : text,
              ),
            ),
            const Spacer(),
            if (selected)
              Icon(Icons.check, size: 16, color: lime),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool value;
  final Color lime;
  final Color text;
  final Color textDim;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.lime,
    required this.text,
    required this.textDim,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        label,
        style: GoogleFonts.notoSansKr(
            fontSize: 14, fontWeight: FontWeight.w500, color: text),
      ),
      subtitle: Text(
        sublabel,
        style: GoogleFonts.notoSansKr(fontSize: 12, color: textDim),
      ),
      value: value,
      activeThumbColor: lime,
      onChanged: onChanged,
    );
  }
}
