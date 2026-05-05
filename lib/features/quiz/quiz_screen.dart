import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/sm2.dart';
import '../../data/database/app_database.dart';
import '../../data/models/cert_json.dart';
import '../../providers/database_provider.dart';
import '../../providers/quiz_providers.dart';
import '../../services/notification_service.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String certId;
  final String mode;
  const QuizScreen({super.key, required this.certId, required this.mode});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  Set<int> _expanded = {0, 1, 2};
  bool _grading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final db = ref.read(databaseProvider);
      final saved = await db.settingsDao.getLastQuizIndex(widget.certId);
      if (saved > 0 && mounted) {
        ref.read(currentQuestionIndexProvider(widget.certId).notifier).state = saved;
      }
    });
  }

  void _navigateToIndex(int newIndex) {
    ref.read(currentQuestionIndexProvider(widget.certId).notifier).state = newIndex;
    ref.read(databaseProvider).settingsDao.setLastQuizIndex(widget.certId, newIndex);
  }

  // "다음" 버튼: 현재 문제를 봤음으로 표시 후 이동
  Future<void> _navigateNext(dynamic q, int idx) async {
    final db = ref.read(databaseProvider);
    final existing = await db.qStateDao.getState(q.id, widget.certId);
    if (existing == null) {
      await db.qStateDao.upsertState(QStatesCompanion(
        questionId: Value(q.id),
        certId: Value(widget.certId),
        masteryLevel: const Value(1),
        easeFactor: const Value(2.5),
        interval: const Value(1),
        repetitions: const Value(0),
        nextReview: Value(DateTime.now().add(const Duration(days: 1))),
        bookmarked: const Value(false),
      ));
    }
    _navigateToIndex(idx + 1);
  }

  void _toggleAccordion(int i) {
    setState(() {
      if (_expanded.contains(i)) {
        _expanded.remove(i);
      } else {
        _expanded.add(i);
      }
    });
  }

  Future<void> _submitGrade(
    int grade,
    dynamic q,
    List<dynamic> questions,
    int currentIndex,
  ) async {
    if (_grading) return;
    setState(() => _grading = true);

    try {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      final today =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final currentState = await db.qStateDao.getState(q.id, widget.certId);
      final sm2 = computeSM2(
        easeFactor: currentState?.easeFactor ?? 2.5,
        interval: currentState?.interval ?? 1,
        repetitions: currentState?.repetitions ?? 0,
        masteryLevel: currentState?.masteryLevel ?? 0,
        grade: grade,
      );

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

      await db.attemptDao.insertAttempt(AttemptsCompanion(
        questionId: Value(q.id),
        certId: Value(widget.certId),
        grade: Value(grade),
        attemptedAt: Value(now),
      ));

      await db.dailyActivityDao.incrementActivity(
        today,
        widget.certId,
        correct: grade >= 2,
      );

      final notifRequested = await db.settingsDao.get('notification_requested');
      if (notifRequested == null) {
        await NotificationService.requestPermission();
        await db.settingsDao.set('notification_requested', '1');
      }
      await NotificationService.rescheduleReminder();

      final next = currentIndex + 1;
      if (next < questions.length) {
        _navigateToIndex(next);
      } else {
        ref.read(databaseProvider).settingsDao.setLastQuizIndex(widget.certId, 0);
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e, st) {
      debugPrint('Error in _submitGrade: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _grading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentQuestionIndexProvider(widget.certId), (prev, next) {
      if (prev != next) {
        setState(() { _expanded = {0, 1, 2}; _grading = false; });
      }
    });

    final questionsAsync = ref.watch(questionsForCertProvider(widget.certId));
    final currentIndex = ref.watch(currentQuestionIndexProvider(widget.certId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
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
          if (questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('문제가 없습니다', style: TextStyle(color: textDim)),
                  const SizedBox(height: 12),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('돌아가기')),
                ],
              ),
            );
          }

          final idx = currentIndex.clamp(0, questions.length - 1);
          final q = questions[idx];
          final progress = (idx + 1) / questions.length;
          final qStateAsync = ref.watch(currentQStateProvider((q.id, widget.certId)));
          final isBookmarked = qStateAsync.valueOrNull?.bookmarked ?? false;

          AiExplanationJson? aiExp;
          try {
            final decoded = jsonDecode(q.aiExplanation);
            if (decoded is Map<String, dynamic>) aiExp = AiExplanationJson.fromJson(decoded);
          } catch (_) {}

          return SafeArea(
            child: Column(
              children: [
                // 상단바
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop(), padding: EdgeInsets.zero),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(value: progress, minHeight: 4, backgroundColor: lime.withAlpha(30), valueColor: AlwaysStoppedAnimation(lime)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${idx + 1}/${questions.length}', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700, color: textDim)),
                    ],
                  ),
                ),

                // 스크롤 영역 - 처음부터 전체 표시
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: [
                      _DifficultyChip(difficulty: q.difficulty),
                      const SizedBox(height: 12),
                      // 문제 카드
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Q.${idx + 1}', style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w700, color: lime)),
                            const SizedBox(height: 12),
                            Text(q.question, style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.w600, height: 1.5, color: text), softWrap: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // 정답 카드 (배지 없이 텍스트만)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: lime.withAlpha(20), borderRadius: BorderRadius.circular(12), border: Border.all(color: lime.withAlpha(60))),
                        child: Text(q.answer, style: GoogleFonts.notoSansKr(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: text)),
                      ),
                      const SizedBox(height: 8),
                      // AI 설명 아코디언
                      if (aiExp != null) ...[
                        _AccordionSection(index: 0, expanded: _expanded, icon: '📖', title: '배경', content: aiExp.background, onToggle: _toggleAccordion, isDark: isDark),
                        _AccordionSection(index: 1, expanded: _expanded, icon: '💡', title: '개념', content: aiExp.concept, onToggle: _toggleAccordion, isDark: isDark),
                        _AccordionSection(index: 2, expanded: _expanded, icon: '🎯', title: '시험팁', content: aiExp.examTip, onToggle: _toggleAccordion, isDark: isDark),
                        _AccordionSection(index: 3, expanded: _expanded, icon: '🧠', title: '암기팁', content: aiExp.memoryTip, onToggle: _toggleAccordion, isDark: isDark, isMemoryTip: true),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // 하단 고정
                Container(
                  decoration: BoxDecoration(color: bg, border: Border(top: BorderSide(color: border))),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 북마크 + 다시볼게요 + 이해했어요
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined, color: isBookmarked ? lime : textDim),
                            onPressed: () async {
                              final db = ref.read(databaseProvider);
                              final current = qStateAsync.valueOrNull;
                              await db.qStateDao.upsertState(QStatesCompanion(questionId: Value(q.id), certId: Value(widget.certId), bookmarked: Value(!(current?.bookmarked ?? false))));
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: _GradeButton(label: '다시 볼게요', color: AppColors.darkRose, enabled: !_grading, onTap: () => _submitGrade(0, q, questions, idx))),
                          const SizedBox(width: 8),
                          Expanded(child: _GradeButton(label: '이해했어요', color: lime, enabled: !_grading, onTap: () => _submitGrade(2, q, questions, idx))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 이전 / 다음
                      Row(
                        children: [
                          GestureDetector(
                            onTap: idx > 0 ? () { _navigateToIndex(idx - 1); } : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(border: Border.all(color: idx > 0 ? border : border.withAlpha(60)), borderRadius: BorderRadius.circular(8)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.chevron_left, size: 16, color: idx > 0 ? textDim : textDim.withAlpha(60)),
                                Text('이전', style: GoogleFonts.notoSansKr(fontSize: 13, color: idx > 0 ? textDim : textDim.withAlpha(60))),
                              ]),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: idx < questions.length - 1 ? () => _navigateNext(q, idx) : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(border: Border.all(color: idx < questions.length - 1 ? border : border.withAlpha(60)), borderRadius: BorderRadius.circular(8)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text('다음', style: GoogleFonts.notoSansKr(fontSize: 13, color: idx < questions.length - 1 ? textDim : textDim.withAlpha(60))),
                                Icon(Icons.chevron_right, size: 16, color: idx < questions.length - 1 ? textDim : textDim.withAlpha(60)),
                              ]),
                            ),
                          ),
                        ],
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
}

class _DifficultyChip extends StatelessWidget {
  final int difficulty;
  const _DifficultyChip({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = difficulty == 1 ? AppColors.diff1 : difficulty == 2 ? AppColors.diff2 : AppColors.diff3;
    final label = difficulty == 1 ? '기본' : difficulty == 2 ? '보통' : '심화';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
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

  const _AccordionSection({required this.index, required this.expanded, required this.icon, required this.title, required this.content, required this.onToggle, required this.isDark, this.isMemoryTip = false});

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
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onToggle(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text('$icon ', style: const TextStyle(fontSize: 16)),
                  Text(title, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w600, color: text)),
                  const Spacer(),
                  Icon(isOpen ? Icons.expand_less : Icons.expand_more, color: textDim, size: 20),
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
                      decoration: BoxDecoration(color: lime.withAlpha(15), borderRadius: BorderRadius.circular(8), border: Border.all(color: lime.withAlpha(80))),
                      child: Text(content, style: GoogleFonts.notoSansKr(fontSize: 14, height: 1.6, color: text)),
                    )
                  : Text(content, style: GoogleFonts.notoSansKr(fontSize: 14, height: 1.6, color: text)),
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

  const _GradeButton({required this.label, required this.color, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 48,
          decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withAlpha(80))),
          alignment: Alignment.center,
          child: Text(label, style: GoogleFonts.notoSansKr(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        ),
      ),
    );
  }
}
