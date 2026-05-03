import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/sm2.dart';
import '../../data/database/app_database.dart';
import '../../data/models/cert_json.dart';
import '../../providers/database_provider.dart';
import '../../providers/quiz_providers.dart';
import '../../services/notification_service.dart';

class ExplanationScreen extends ConsumerStatefulWidget {
  final String certId;
  final int questionId;
  final bool showGradeButtons;
  const ExplanationScreen({
    super.key,
    required this.certId,
    required this.questionId,
    this.showGradeButtons = true,
  });

  @override
  ConsumerState<ExplanationScreen> createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends ConsumerState<ExplanationScreen> {
  final Set<int> _expanded = {0}; // 배경 섹션 기본 펼침
  bool _grading = false;

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsForCertProvider(widget.certId));
    final currentIndex = ref.watch(currentQuestionIndexProvider(widget.certId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;

    return Scaffold(
      backgroundColor: bg,
      body: questionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (questions) {
          final q = questions.firstWhere(
            (q) => q.id == widget.questionId,
            orElse: () =>
                questions[currentIndex.clamp(0, questions.length - 1)],
          );
          // Show progress based on actual position in list
          final actualIndex = questions.indexWhere((q) => q.id == widget.questionId);
          final displayIndex = actualIndex >= 0 ? actualIndex : currentIndex;
          final progress = (displayIndex + 1) / questions.length;

          AiExplanationJson? aiExp;
          try {
            final decoded = jsonDecode(q.aiExplanation);
            if (decoded is Map<String, dynamic>) {
              aiExp = AiExplanationJson.fromJson(decoded);
            }
          } catch (_) {}

          return SafeArea(
            child: Column(
              children: [
                // 상단 바
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 4,
                            backgroundColor: lime.withAlpha(30),
                            valueColor: AlwaysStoppedAnimation(lime),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${displayIndex + 1}/${questions.length}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: textDim,
                        ),
                      ),
                    ],
                  ),
                ),

                // 스크롤 영역
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: [
                      // 문제 카드 — wrong_note에서 열 때만 표시
                      if (!widget.showGradeButtons) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: border),
                          ),
                          child: Text(
                            q.question,
                            style: GoogleFonts.notoSansKr(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.6,
                              color: text,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      // 정답 카드 ("정답" 칩은 wrong_note 뷰에서 숨김)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: lime.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: lime.withAlpha(60)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.showGradeButtons) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: lime,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '정답',
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.darkBg
                                        : AppColors.lightBg,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Text(
                              q.answer,
                              style: GoogleFonts.notoSansKr(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.6,
                                color: text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // AI 설명 아코디언
                      if (aiExp != null) ...[
                        _AccordionSection(
                          index: 0,
                          expanded: _expanded,
                          icon: '📖',
                          title: '배경',
                          content: aiExp.background,
                          onToggle: _toggleSection,
                          isDark: isDark,
                        ),
                        _AccordionSection(
                          index: 1,
                          expanded: _expanded,
                          icon: '💡',
                          title: '개념',
                          content: aiExp.concept,
                          onToggle: _toggleSection,
                          isDark: isDark,
                        ),
                        _AccordionSection(
                          index: 2,
                          expanded: _expanded,
                          icon: '🎯',
                          title: '시험팁',
                          content: aiExp.examTip,
                          onToggle: _toggleSection,
                          isDark: isDark,
                        ),
                        _AccordionSection(
                          index: 3,
                          expanded: _expanded,
                          icon: '🧠',
                          title: '암기팁',
                          content: aiExp.memoryTip,
                          onToggle: _toggleSection,
                          isDark: isDark,
                          isMemoryTip: true,
                        ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // 자가평가 버튼 (sticky bottom) — wrong_note에서 열 때는 숨김
                if (widget.showGradeButtons)
                  Container(
                    decoration: BoxDecoration(
                      color: bg,
                      border: Border(top: BorderSide(color: border)),
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _GradeButton(
                            label: '다시 볼게요',
                            color: AppColors.darkRose,
                            enabled: !_grading,
                            onTap: () => _submitGrade(
                                context, ref, q, 0, questions, currentIndex),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _GradeButton(
                            label: '이해했어요',
                            color: lime,
                            enabled: !_grading,
                            onTap: () => _submitGrade(
                                context, ref, q, 2, questions, currentIndex),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _toggleSection(int index) {
    setState(() {
      if (_expanded.contains(index)) {
        _expanded.remove(index);
      } else {
        _expanded.add(index);
      }
    });
  }

  Future<void> _submitGrade(
    BuildContext context,
    WidgetRef ref,
    dynamic q,
    int grade,
    List<dynamic> questions,
    int currentIndex,
  ) async {
    if (_grading) return;
    setState(() => _grading = true);

    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // 1. Load current SM-2 state
    final currentState = await db.qStateDao.getState(q.id, widget.certId);

    // 2. Compute SM-2
    final sm2 = computeSM2(
      easeFactor: currentState?.easeFactor ?? 2.5,
      interval: currentState?.interval ?? 1,
      repetitions: currentState?.repetitions ?? 0,
      masteryLevel: currentState?.masteryLevel ?? 0,
      grade: grade,
    );

    // 3. Upsert QState with SM-2 results (preserve bookmark)
    await db.qStateDao.upsertState(QStatesCompanion(
      questionId: Value(q.id),
      certId: Value(widget.certId),
      easeFactor: Value(sm2.easeFactor),
      interval: Value(sm2.interval),
      repetitions: Value(sm2.repetitions),
      nextReview: Value(sm2.nextReview),
      masteryLevel: Value(sm2.masteryLevel),
      bookmarked: currentState != null
          ? Value(currentState.bookmarked)
          : const Value(false),
    ));

    // 4. Record attempt
    await db.attemptDao.insertAttempt(AttemptsCompanion(
      questionId: Value(q.id),
      certId: Value(widget.certId),
      grade: Value(grade),
      attemptedAt: Value(now),
    ));

    // 5. Update daily activity
    await db.dailyActivityDao.incrementActivity(
      today,
      widget.certId,
      correct: grade >= 2,
    );

    // 6. First-time: request notification permission + schedule reminder
    final notifRequested =
        await db.settingsDao.get('notification_requested');
    if (notifRequested == null) {
      await NotificationService.requestPermission();
      await db.settingsDao.set('notification_requested', '1');
    }
    await NotificationService.rescheduleReminder();
    await NotificationService.scheduleReviewNotification(sm2.nextReview);

    // 7. Advance quiz index
    final next = currentIndex + 1;
    if (next < questions.length) {
      ref.read(currentQuestionIndexProvider(widget.certId).notifier).state =
          next;
    }

    if (context.mounted) context.pop();
  }
}

class _AccordionSection extends StatelessWidget {
  final int index;
  final Set<int> expanded;
  final String icon;
  final String title;
  final String content;
  final void Function(int) onToggle;
  final bool isDark;
  final bool isMemoryTip;

  const _AccordionSection({
    required this.index,
    required this.expanded,
    required this.icon,
    required this.title,
    required this.content,
    required this.onToggle,
    required this.isDark,
    this.isMemoryTip = false,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = expanded.contains(index);
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onToggle(index),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text('$icon ', style: const TextStyle(fontSize: 16)),
                  Text(
                    title,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: text,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isOpen ? Icons.expand_less : Icons.expand_more,
                    color: textDim,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: isMemoryTip
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: lime.withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: lime.withAlpha(80)),
                      ),
                      child: Text(
                        content,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 14,
                          height: 1.6,
                          color: text,
                        ),
                      ),
                    )
                  : Text(
                      content,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 14,
                        height: 1.6,
                        color: text,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

class _GradeButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _GradeButton({
    required this.label,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(80)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.notoSansKr(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
