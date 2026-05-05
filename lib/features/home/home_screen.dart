import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/ads/ad_banner_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/cert_providers.dart';
import '../../providers/study_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certsAsync = ref.watch(allCertsProvider);
    final streakAsync = ref.watch(streakProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMute = isDark ? AppColors.darkTextMute : AppColors.lightTextMute;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;

    final streak = streakAsync.valueOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자격증 마스터',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w800),
        ),
        actions: [
          // 스트릭 배지
          if (streak > 0)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: lime.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: lime.withAlpha(60)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🔥',
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$streak일',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: lime,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: certsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (certs) {
          if (certs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('자격증 데이터 로딩 중...', style: TextStyle(color: textMute)),
                ],
              ),
            );
          }

          // 카테고리별 그룹화
          final grouped = <String, List<dynamic>>{};
          for (final c in certs) {
            grouped.putIfAbsent(c.category, () => []).add(c);
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            children: [
              for (final entry in grouped.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                  child: Text(
                    entry.key,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: textMute,
                    ).copyWith(inherit: true),
                  ),
                ),
                for (final cert in entry.value)
                  _CertTile(certId: cert.certId),
              ],
              const SizedBox(height: 24),
            ],
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AdBannerWidget(),
          NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
              NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined), label: '통계'),
            ],
            selectedIndex: 0,
            onDestinationSelected: (i) {
              if (i == 1) context.push('/stats');
            },
          ),
        ],
      ),
    );
  }
}

class _CertTile extends ConsumerWidget {
  final String certId;
  const _CertTile({required this.certId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certAsync = ref.watch(certByIdProvider(certId));
    final progressAsync = ref.watch(certProgressProvider(certId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final text = isDark ? AppColors.darkText : AppColors.lightText;

    return certAsync.when(
      loading: () => const SizedBox(height: 72),
      error: (e, _) => const SizedBox.shrink(),
      data: (cert) {
        if (cert == null) return const SizedBox.shrink();
        final completed = progressAsync.valueOrNull ?? 0;
        final progress =
            cert.totalItems > 0 ? completed / cert.totalItems : 0.0;

        return GestureDetector(
          onTap: () => context.push('/cert/${cert.certId}'),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cert.certName,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: text,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: lime.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        cert.category,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: lime,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$completed / ${cert.totalItems}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: textDim,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: lime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: lime.withAlpha(30),
                    valueColor: AlwaysStoppedAnimation(lime),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
