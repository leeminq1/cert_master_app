import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/cert_providers.dart';

class CertDetailScreen extends ConsumerWidget {
  final String certId;
  const CertDetailScreen({super.key, required this.certId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certAsync = ref.watch(certByIdProvider(certId));
    final progressAsync = ref.watch(certProgressProvider(certId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: certAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (cert) {
          if (cert == null) return const Center(child: Text('자격증을 찾을 수 없습니다'));
          final completed = progressAsync.valueOrNull ?? 0;
          final progress =
              cert.totalItems > 0 ? completed / cert.totalItems : 0.0;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 8),
                      Text(
                        cert.certName,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: text,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '${cert.totalItems}문항',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              color: textDim,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: lime.withAlpha(30),
                                valueColor: AlwaysStoppedAnimation(lime),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: lime,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                sliver: SliverGrid(
                  delegate: SliverChildListDelegate([
                    _ModeCard(
                      icon: Icons.list_alt_outlined,
                      title: '전체 학습',
                      subtitle: '${cert.totalItems}문항',
                      onTap: () =>
                          context.push('/cert/$certId/quiz?mode=all'),
                    ),
                    _ModeCard(
                      icon: Icons.bolt_outlined,
                      title: '1분 핵심',
                      subtitle: '핵심 개념만',
                      onTap: () => context.push('/cert/$certId/one-min'),
                    ),
                    _ModeCard(
                      icon: Icons.link_outlined,
                      title: '유사 개념',
                      subtitle: '준비 중',
                      onTap: null,
                      dimmed: true,
                    ),
                    _ModeCard(
                      icon: Icons.bookmark_border_outlined,
                      title: '오답·북마크',
                      subtitle: '복습',
                      onTap: () =>
                          context.push('/cert/$certId/wrong-note'),
                    ),
                    _ModeCard(
                      icon: Icons.signal_cellular_alt_outlined,
                      title: '난이도별',
                      subtitle: '준비 중',
                      onTap: null,
                      dimmed: true,
                    ),
                    _ModeCard(
                      icon: Icons.assignment_outlined,
                      title: '모의고사',
                      subtitle: '60문항',
                      onTap: () => context.push('/mock-exam/$certId'),
                    ),
                  ]),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.3,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool dimmed;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: dimmed ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: lime, size: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: text,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 11,
                      color: textDim,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
