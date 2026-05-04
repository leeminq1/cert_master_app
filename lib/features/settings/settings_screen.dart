import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import '../../providers/cert_providers.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_providers.dart';
import '../../providers/study_providers.dart';
import '../../services/backup_service.dart';
import '../../services/notification_service.dart';

final _studyStatsProvider = FutureProvider.autoDispose<({int today, int totalCompleted})>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final todayStr =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  final activityMap = await db.dailyActivityDao.getActivityCountByDate();
  final today = activityMap[todayStr] ?? 0;
  final result = await db.customSelect(
    'SELECT COUNT(*) as c FROM q_states WHERE mastery_level > 0',
    readsFrom: {db.qStates},
  ).getSingle();
  final totalCompleted = result.read<int>('c');
  return (today: today, totalCompleted: totalCompleted);
});

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  TimeOfDay _dailyTime = const TimeOfDay(hour: 9, minute: 0);
  bool _dailyEnabled = false;
  bool _exportLoading = false;
  bool _restoreLoading = false;

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

  Future<void> _exportBackup() async {
    setState(() => _exportLoading = true);
    try {
      await BackupService.export(ref.read(databaseProvider));
    } finally {
      if (mounted) setState(() => _exportLoading = false);
    }
  }

  Future<void> _restoreBackup() async {
    setState(() => _restoreLoading = true);
    final err = await BackupService.restore(ref.read(databaseProvider));
    if (!mounted) return;
    setState(() => _restoreLoading = false);
    if (err != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('복원 완료!')),
      );
    }
  }

  Future<void> _showResetCertSheet(
      BuildContext ctx, List<Cert> certs, Color surface, Color border,
      Color text, Color textDim, Color rose) async {
    await showModalBottomSheet(
      context: ctx,
      backgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: border),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text('초기화할 자격증 선택',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 14, fontWeight: FontWeight.w700, color: text)),
            ),
            for (final cert in certs)
              ListTile(
                title: Text(cert.certName,
                    style: GoogleFonts.notoSansKr(
                        fontSize: 14, color: text)),
                subtitle: Text(cert.category,
                    style: GoogleFonts.notoSansKr(
                        fontSize: 12, color: textDim)),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _confirmResetCert(cert, text, textDim, rose, surface, border);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmResetCert(
      Cert cert, Color text, Color textDim, Color rose,
      Color surface, Color border) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
        title: Text('${cert.certName} 초기화',
            style: GoogleFonts.notoSansKr(
                fontWeight: FontWeight.w700, color: text)),
        content: Text('해당 자격증의 모든 학습 기록이 삭제됩니다.',
            style: GoogleFonts.notoSansKr(fontSize: 14, color: textDim)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('취소',
                  style: GoogleFonts.notoSansKr(color: textDim))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('초기화',
                  style: GoogleFonts.notoSansKr(
                      color: rose, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(databaseProvider).deleteUserDataForCert(cert.certId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${cert.certName} 초기화 완료')),
        );
      }
    }
  }

  Future<void> _confirmFullReset(
      Color text, Color textDim, Color rose, Color surface, Color border) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
        title: Text('전체 초기화',
            style: GoogleFonts.notoSansKr(
                fontWeight: FontWeight.w700, color: rose)),
        content: Text('모든 자격증의 학습 기록이 영구적으로 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.',
            style: GoogleFonts.notoSansKr(fontSize: 14, color: textDim)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('취소',
                  style: GoogleFonts.notoSansKr(color: textDim))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('전체 초기화',
                  style: GoogleFonts.notoSansKr(
                      color: rose, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(databaseProvider).deleteAllUserData();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('전체 초기화 완료')));
      }
    }
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
    final rose = isDark ? AppColors.darkRose : AppColors.lightRose;

    final themeMode = ref.watch(themeModeProvider);
    final notifEnabled = ref.watch(notificationEnabledProvider);
    final fontScale = ref.watch(fontScaleProvider);
    final dailyGoal = ref.watch(dailyGoalProvider);
    final certsAsync = ref.watch(allCertsProvider);
    final streakAsync = ref.watch(streakProvider);
    final studyStatsAsync = ref.watch(_studyStatsProvider);

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
          // ── MY STUDY ───────────────────────────────────────────────────────
          _SectionHeader(label: '내 학습', textDim: textDim),
          _SettingsCard(surface: surface, border: border, children: [
            _InfoTile(
              label: '오늘 학습',
              value: studyStatsAsync.when(
                  data: (s) => '${s.today}문항',
                  loading: () => '-',
                  error: (_, _) => '-'),
              lime: lime,
              text: text,
              textDim: textDim,
            ),
            Divider(height: 1, color: border),
            _InfoTile(
              label: '전체 완료',
              value: studyStatsAsync.when(
                  data: (s) => '${s.totalCompleted}문항',
                  loading: () => '-',
                  error: (_, _) => '-'),
              lime: lime,
              text: text,
              textDim: textDim,
            ),
            Divider(height: 1, color: border),
            _InfoTile(
              label: '연속 학습일',
              value: streakAsync.when(
                  data: (s) => '$s일',
                  loading: () => '-',
                  error: (_, _) => '-'),
              lime: lime,
              text: text,
              textDim: textDim,
            ),
          ]),
          const SizedBox(height: 20),

          // ── 테마 ───────────────────────────────────────────────────────────
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

          // ── 화면 ───────────────────────────────────────────────────────────
          _SectionHeader(label: '화면', textDim: textDim),
          _SettingsCard(surface: surface, border: border, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('폰트 크기',
                      style: GoogleFonts.notoSansKr(
                          fontSize: 14, fontWeight: FontWeight.w500,
                          color: text)),
                  Text(
                    '${(fontScale * 100).round()}%',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 13, fontWeight: FontWeight.w700, color: lime),
                  ),
                ],
              ),
            ),
            Slider(
              value: fontScale,
              min: 0.85,
              max: 1.20,
              divisions: 7,
              activeColor: lime,
              onChanged: (v) =>
                  ref.read(fontScaleProvider.notifier).set(v),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                '미리보기: 자격증 마스터로 합격하세요',
                style: GoogleFonts.notoSansKr(fontSize: 13, color: textDim),
              ),
            ),
          ]),
          const SizedBox(height: 20),

          // ── 알림 ───────────────────────────────────────────────────────────
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
            Divider(height: 1, color: border),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('일일 목표',
                      style: GoogleFonts.notoSansKr(
                          fontSize: 14, fontWeight: FontWeight.w500,
                          color: text)),
                  Text(
                    '$dailyGoal문항',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 13, fontWeight: FontWeight.w700, color: lime),
                  ),
                ],
              ),
            ),
            Slider(
              value: dailyGoal.toDouble(),
              min: 5,
              max: 50,
              divisions: 9,
              activeColor: lime,
              onChanged: (v) =>
                  ref.read(dailyGoalProvider.notifier).set(v.round()),
            ),
            const SizedBox(height: 4),
          ]),
          const SizedBox(height: 20),

          // ── 데이터 ─────────────────────────────────────────────────────────
          _SectionHeader(label: '데이터', textDim: textDim),
          _SettingsCard(surface: surface, border: border, children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Icon(Icons.upload_outlined, color: lime, size: 20),
              title: Text('학습 기록 내보내기',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 14, fontWeight: FontWeight.w500, color: text)),
              subtitle: Text('JSON 파일로 백업',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 12, color: textDim)),
              trailing: _exportLoading
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.chevron_right, color: textDim, size: 18),
              onTap: _exportLoading ? null : _exportBackup,
            ),
            Divider(height: 1, color: border),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Icon(Icons.download_outlined, color: lime, size: 20),
              title: Text('백업에서 복원',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 14, fontWeight: FontWeight.w500, color: text)),
              subtitle: Text('JSON 파일에서 불러오기',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 12, color: textDim)),
              trailing: _restoreLoading
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.chevron_right, color: textDim, size: 18),
              onTap: _restoreLoading ? null : _restoreBackup,
            ),
          ]),
          const SizedBox(height: 20),

          // ── DANGER ZONE ────────────────────────────────────────────────────
          _SectionHeader(label: '초기화', textDim: textDim),
          _SettingsCard(surface: surface, border: border, children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Icon(Icons.refresh_outlined, color: rose, size: 20),
              title: Text('자격증별 초기화',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 14, fontWeight: FontWeight.w500, color: text)),
              subtitle: Text('특정 자격증 학습 기록 삭제',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 12, color: textDim)),
              onTap: () => certsAsync.whenData(
                (certs) => _showResetCertSheet(
                  context, certs, surface, border, text, textDim, rose,
                ),
              ),
            ),
            Divider(height: 1, color: border),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Icon(Icons.delete_forever_outlined, color: rose, size: 20),
              title: Text('전체 초기화',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 14, fontWeight: FontWeight.w700, color: rose)),
              subtitle: Text('모든 학습 기록 영구 삭제',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 12, color: textDim)),
              onTap: () => _confirmFullReset(
                  text, textDim, rose, surface, border),
            ),
          ]),
          const SizedBox(height: 20),

          // ── ABOUT ──────────────────────────────────────────────────────────
          _SectionHeader(label: '앱 정보', textDim: textDim),
          _SettingsCard(surface: surface, border: border, children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text('버전',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 14, fontWeight: FontWeight.w500, color: text)),
              trailing: Text('v1.0.0',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 13, color: textDim)),
            ),
            Divider(height: 1, color: border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.lock_outline, size: 14, color: textDim),
                  const SizedBox(width: 6),
                  Text('회원가입 없음 · 외부 전송 없음 · 완전 오프라인',
                      style: GoogleFonts.notoSansKr(
                          fontSize: 11, color: textDim)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 32),
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

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final Color lime;
  final Color text;
  final Color textDim;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.lime,
    required this.text,
    required this.textDim,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.notoSansKr(
                  fontSize: 14, fontWeight: FontWeight.w500, color: text)),
          Text(value,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 14, fontWeight: FontWeight.w700, color: lime)),
        ],
      ),
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
