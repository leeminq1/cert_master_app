import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/study_providers.dart';

// ── Data bundle ──────────────────────────────────────────────────────────────

typedef _StatsData = ({
  int mastered,
  int totalQuestions,
  int streak,
  Map<String, int> activityByDate,
  Map<String, (int correct, int total)> accuracyByCert,
  List<Cert> certs,
});

final _statsProvider = FutureProvider.autoDispose<_StatsData>((ref) async {
  final db = ref.watch(databaseProvider);
  final certs = await db.certDao.getAllCerts();
  final totalQuestions = certs.fold(0, (sum, c) => sum + c.totalItems);
  final mastered = await db.qStateDao.countMastered();
  final activityByDate = await db.dailyActivityDao.getActivityCountByDate();
  final accuracyByCert = await db.dailyActivityDao.getAccuracyByCert();
  final streak = await ref.watch(streakProvider.future);
  return (
    mastered: mastered,
    totalQuestions: totalQuestions,
    streak: streak,
    activityByDate: activityByDate,
    accuracyByCert: accuracyByCert,
    certs: certs,
  );
});

// ── Screen ────────────────────────────────────────────────────────────────────

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(_statsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final text = isDark ? AppColors.darkText : AppColors.lightText;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          '학습 통계',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700, color: text),
        ),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (d) => _StatsBody(data: d),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _StatsBody extends StatelessWidget {
  final _StatsData data;
  const _StatsBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;
    final amber = isDark ? AppColors.darkAmber : AppColors.lightAmber;
    final rose = isDark ? AppColors.darkRose : AppColors.lightRose;

    final scoreRaw = data.totalQuestions > 0
        ? (data.mastered / data.totalQuestions * 100).round()
        : 0;
    // 1문항이라도 숙달 시 최소 1점 표시
    final scorePercent = data.mastered > 0 ? max(1, scoreRaw) : 0;
    final scoreColor =
        scorePercent >= 60 ? lime : (scorePercent >= 40 ? amber : rose);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // ── 전체 자격증 진도율 ──────────────────────────────
        _Card(surface: surface, border: border, child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('전체 자격증 진도율',
                        style: GoogleFonts.notoSansKr(
                            fontSize: 12, color: textDim,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('${data.mastered} / ${data.totalQuestions} 문항 학습',
                        style: GoogleFonts.notoSansKr(
                            fontSize: 12, color: textDim)),
                  ],
                ),
              ),
              Text(
                '$scorePercent',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 56, fontWeight: FontWeight.w900,
                    color: scoreColor),
              ),
              Text('%',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 16, fontWeight: FontWeight.w600,
                      color: scoreColor)),
            ],
          ),
        )),
        const SizedBox(height: 16),

        // ── 히트맵 ────────────────────────────────
        _Card(surface: surface, border: border, child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('12주 학습 기록',
                  style: GoogleFonts.notoSansKr(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: textDim)),
              const SizedBox(height: 12),
              SizedBox(
                height: 96,
                child: CustomPaint(
                  painter: _HeatmapPainter(
                    activityByDate: data.activityByDate,
                    surfaceColor: isDark
                        ? AppColors.darkSurface2
                        : AppColors.lightSurface2,
                    limeColor: lime,
                  ),
                  size: const Size(double.infinity, 96),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('12주 전',
                      style: GoogleFonts.jetBrainsMono(
                          fontSize: 9, color: textDim)),
                  Text('오늘',
                      style: GoogleFonts.jetBrainsMono(
                          fontSize: 9, color: textDim)),
                ],
              ),
            ],
          ),
        )),
        const SizedBox(height: 16),

        // ── 스트릭 ────────────────────────────────
        _Card(surface: surface, border: border, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Text('🔥', style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data.streak}일째 연속 학습',
                      style: GoogleFonts.notoSansKr(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          color: text)),
                  Text('매일 꾸준히 학습하세요',
                      style: GoogleFonts.notoSansKr(
                          fontSize: 12, color: textDim)),
                ],
              ),
            ],
          ),
        )),
        const SizedBox(height: 16),

        // ── 카테고리별 정확도 ──────────────────────
        if (data.accuracyByCert.isNotEmpty) ...[
          Text('자격증별 정확도',
              style: GoogleFonts.notoSansKr(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: textDim)),
          const SizedBox(height: 8),
          _AccuracySection(
            certs: data.certs,
            accuracyByCert: data.accuracyByCert,
            surface: surface,
            border: border,
            text: text,
            textDim: textDim,
            lime: lime,
            rose: rose,
          ),
        ],
      ],
    );
  }
}

// ── Card wrapper ──────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Color surface;
  final Color border;
  final Widget child;
  const _Card({required this.surface, required this.border, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: child,
      );
}

// ── Heatmap painter ───────────────────────────────────────────────────────────

class _HeatmapPainter extends CustomPainter {
  final Map<String, int> activityByDate;
  final Color surfaceColor;
  final Color limeColor;

  const _HeatmapPainter({
    required this.activityByDate,
    required this.surfaceColor,
    required this.limeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const cols = 12;
    const rows = 7;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    final now = DateTime.now();
    // Start from Monday 11 weeks ago
    final startDate = now.subtract(Duration(days: 83));

    for (int w = 0; w < cols; w++) {
      for (int d = 0; d < rows; d++) {
        final date = startDate.add(Duration(days: w * 7 + d));
        final dateStr =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final count = activityByDate[dateStr] ?? 0;

        final color = count == 0
            ? surfaceColor
            : count < 4
                ? limeColor.withAlpha(70)
                : count < 10
                    ? limeColor.withAlpha(140)
                    : limeColor;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              w * cellW + 1.5,
              d * cellH + 1.5,
              cellW - 3,
              cellH - 3,
            ),
            const Radius.circular(2),
          ),
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_HeatmapPainter old) =>
      old.activityByDate != activityByDate;
}

// ── Accuracy section ──────────────────────────────────────────────────────────

class _AccuracySection extends StatelessWidget {
  final List<Cert> certs;
  final Map<String, (int correct, int total)> accuracyByCert;
  final Color surface;
  final Color border;
  final Color text;
  final Color textDim;
  final Color lime;
  final Color rose;

  const _AccuracySection({
    required this.certs,
    required this.accuracyByCert,
    required this.surface,
    required this.border,
    required this.text,
    required this.textDim,
    required this.lime,
    required this.rose,
  });

  @override
  Widget build(BuildContext context) {
    final entries = accuracyByCert.entries
        .where((e) => e.value.$2 > 0)
        .map((e) {
          final cert = certs.firstWhere((c) => c.certId == e.key,
              orElse: () => Cert(
                  certId: e.key,
                  certName: e.key,
                  category: '',
                  totalItems: 0,
                  version: ''));
          final accuracy = e.value.$1 / e.value.$2;
          return (cert: cert, accuracy: accuracy, total: e.value.$2);
        })
        .toList()
      ..sort((a, b) => a.accuracy.compareTo(b.accuracy));

    final weakEntries = entries.take(min(3, entries.length)).toList();
    final otherEntries = entries.skip(weakEntries.length).toList();
    final sorted = [...weakEntries, ...otherEntries];

    return _Card(
      surface: surface,
      border: border,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < min(6, sorted.length); i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _AccuracyRow(
                label: sorted[i].cert.certName,
                accuracy: sorted[i].accuracy,
                total: sorted[i].total,
                barColor: i < weakEntries.length ? rose : lime,
                text: text,
                textDim: textDim,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AccuracyRow extends StatelessWidget {
  final String label;
  final double accuracy;
  final int total;
  final Color barColor;
  final Color text;
  final Color textDim;

  const _AccuracyRow({
    required this.label,
    required this.accuracy,
    required this.total,
    required this.barColor,
    required this.text,
    required this.textDim,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.notoSansKr(fontSize: 12, color: text),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(accuracy * 100).round()}%',
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 12, fontWeight: FontWeight.w700, color: barColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: accuracy,
            minHeight: 5,
            backgroundColor: barColor.withAlpha(30),
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }
}
