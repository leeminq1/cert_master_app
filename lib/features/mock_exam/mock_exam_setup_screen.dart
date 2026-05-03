import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/cert_providers.dart';

class MockExamSetupScreen extends ConsumerWidget {
  final String certId;
  const MockExamSetupScreen({super.key, required this.certId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certAsync = ref.watch(certByIdProvider(certId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: text),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '모의고사',
          style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: text),
        ),
      ),
      body: certAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (cert) {
          if (cert == null) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  cert.certName,
                  style: GoogleFonts.notoSansKr(
                      fontSize: 22, fontWeight: FontWeight.w800, color: text),
                ),
                const SizedBox(height: 8),
                Text(
                  '모의고사로 실력을 점검해보세요',
                  style: GoogleFonts.notoSansKr(fontSize: 14, color: textDim),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(icon: Icons.quiz_outlined,       label: '랜덤 60문항  (전체 ${cert.totalItems}문항 중)', textDim: textDim, lime: lime),
                      const SizedBox(height: 14),
                      _InfoRow(icon: Icons.timer_outlined,       label: '제한시간 60분',                                textDim: textDim, lime: lime),
                      const SizedBox(height: 14),
                      _InfoRow(icon: Icons.check_circle_outline, label: '자가평가 방식 (맞았어요 / 틀렸어요)',          textDim: textDim, lime: lime),
                      const SizedBox(height: 14),
                      _InfoRow(icon: Icons.school_outlined,      label: '합격 기준 60% (36문항 이상)',                  textDim: textDim, lime: lime),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lime,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => context.push('/mock-exam/$certId/active'),
                    child: Text(
                      '시작하기',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkBg : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textDim, lime;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.textDim,
    required this.lime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: lime),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: GoogleFonts.notoSansKr(fontSize: 14, color: textDim)),
        ),
      ],
    );
  }
}
