import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class MockExamResultScreen extends StatelessWidget {
  final String certId;
  final int correct;
  final int total;
  final int elapsedSeconds;

  const MockExamResultScreen({
    super.key,
    required this.certId,
    required this.correct,
    required this.total,
    required this.elapsedSeconds,
  });

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

    final scorePercent = total > 0 ? (correct / total * 100).round() : 0;
    final passed = scorePercent >= 60;
    final resultColor = passed ? lime : rose;
    final elapsed = '${(elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(elapsedSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('결과',
            style: GoogleFonts.notoSansKr(
                fontSize: 16, fontWeight: FontWeight.w700, color: text)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: resultColor.withAlpha(30),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: resultColor.withAlpha(80)),
              ),
              child: Text(
                passed ? '합격' : '불합격',
                style: GoogleFonts.notoSansKr(
                    fontSize: 14, fontWeight: FontWeight.w700, color: resultColor),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$scorePercent점',
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 56, fontWeight: FontWeight.w900, color: resultColor),
            ),
            Text(
              '$correct / $total 문항 정답',
              style: GoogleFonts.notoSansKr(fontSize: 14, color: textDim),
            ),
            const SizedBox(height: 4),
            Text(
              '소요시간 $elapsed',
              style: GoogleFonts.jetBrainsMono(fontSize: 12, color: textDim),
            ),
            const SizedBox(height: 32),
            // Score bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: total > 0 ? correct / total : 0,
                      backgroundColor: lime.withAlpha(30),
                      valueColor: AlwaysStoppedAnimation(resultColor),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0%',
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 11, color: textDim)),
                      Text('합격선 60%',
                          style: GoogleFonts.notoSansKr(
                              fontSize: 11, color: textDim)),
                      Text('100%',
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 11, color: textDim)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => context.go('/cert/$certId'),
                    child: Text('과목으로',
                        style: GoogleFonts.notoSansKr(
                            fontWeight: FontWeight.w600, color: textDim)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lime,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => context.go('/mock-exam/$certId'),
                    child: Text(
                      '다시하기',
                      style: GoogleFonts.notoSansKr(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkBg : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
