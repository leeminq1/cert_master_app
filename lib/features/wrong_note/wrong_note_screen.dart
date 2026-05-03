import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/quiz_providers.dart';
import '../../providers/study_providers.dart';

class WrongNoteScreen extends ConsumerStatefulWidget {
  final String certId;
  const WrongNoteScreen({super.key, required this.certId});

  @override
  ConsumerState<WrongNoteScreen> createState() => _WrongNoteScreenState();
}

class _WrongNoteScreenState extends ConsumerState<WrongNoteScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;
    final amber = isDark ? AppColors.darkAmber : AppColors.lightAmber;
    final rose = isDark ? AppColors.darkRose : AppColors.lightRose;

    final questionsAsync = ref.watch(questionsForCertProvider(widget.certId));
    final qStatesAsync = ref.watch(certQStatesProvider(widget.certId));

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(
          '오답·북마크',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tab,
          labelColor: lime,
          unselectedLabelColor:
              isDark ? AppColors.darkTextDim : AppColors.lightTextDim,
          indicatorColor: lime,
          indicatorWeight: 2,
          labelStyle:
              GoogleFonts.notoSansKr(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '다시보는 개념'),
            Tab(text: '북마크'),
          ],
        ),
      ),
      body: questionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (questions) {
          return qStatesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('오류: $e')),
            data: (qStates) {
              // Build map: questionId → QState
              final stateMap = {
                for (final s in qStates) s.questionId: s,
              };

              // 다시보는 개념: 시도했지만 아직 완전히 이해하지 못한 문제
              // (QState 존재 && masteryLevel == 0)
              final retry = questions.where((q) {
                final s = stateMap[q.id];
                return s != null && s.masteryLevel == 0;
              }).toList();

              // 북마크
              final bookmarked = questions.where((q) {
                return stateMap[q.id]?.bookmarked == true;
              }).toList();

              return TabBarView(
                controller: _tab,
                children: [
                  _QuestionList(
                    certId: widget.certId,
                    questions: retry,
                    emptyLabel: '다시 볼 문제가 없습니다.\n문제를 풀면 여기에 표시됩니다.',
                    badgeColor: rose,
                    isDark: isDark,
                    bg: bg,
                    surface: surface,
                    border: border,
                    text: text,
                    onRemove: (q) async {
                      final db = ref.read(databaseProvider);
                      final state = await db.qStateDao.getState(q.id, widget.certId);
                      if (state == null) return;
                      await db.qStateDao.upsertState(QStatesCompanion(
                        questionId: Value(q.id),
                        certId: Value(widget.certId),
                        easeFactor: Value(state.easeFactor),
                        interval: Value(state.interval),
                        repetitions: Value(state.repetitions),
                        nextReview: Value(state.nextReview),
                        masteryLevel: const Value(1),
                        bookmarked: Value(state.bookmarked),
                      ));
                    },
                  ),
                  _QuestionList(
                    certId: widget.certId,
                    questions: bookmarked,
                    emptyLabel: '북마크한 문제가 없습니다.\n문제 풀기 화면에서 ★ 아이콘을 탭하세요.',
                    badgeColor: amber,
                    isDark: isDark,
                    bg: bg,
                    surface: surface,
                    border: border,
                    text: text,
                    onRemove: (q) async {
                      final db = ref.read(databaseProvider);
                      final state = await db.qStateDao.getState(q.id, widget.certId);
                      if (state == null) return;
                      await db.qStateDao.upsertState(QStatesCompanion(
                        questionId: Value(q.id),
                        certId: Value(widget.certId),
                        easeFactor: Value(state.easeFactor),
                        interval: Value(state.interval),
                        repetitions: Value(state.repetitions),
                        nextReview: Value(state.nextReview),
                        masteryLevel: Value(state.masteryLevel),
                        bookmarked: const Value(false),
                      ));
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _QuestionList extends StatelessWidget {
  final String certId;
  final List<Question> questions;
  final String emptyLabel;
  final Color badgeColor;
  final bool isDark;
  final Color bg;
  final Color surface;
  final Color border;
  final Color text;
  final Future<void> Function(Question) onRemove;

  const _QuestionList({
    required this.certId,
    required this.questions,
    required this.emptyLabel,
    required this.badgeColor,
    required this.isDark,
    required this.bg,
    required this.surface,
    required this.border,
    required this.text,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    if (questions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            emptyLabel,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              color: textDim,
              height: 1.7,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      itemCount: questions.length,
      itemBuilder: (context, i) {
        final q = questions[i];
        return GestureDetector(
          onTap: () => context.push(
            '/cert/$certId/explanation?questionId=${q.id}',
            extra: false,
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(14, 10, 6, 14),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _diffLabel(q.difficulty),
                        style: GoogleFonts.notoSansKr(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: badgeColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // 삭제 버튼
                    GestureDetector(
                      onTap: () => onRemove(q),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.close, size: 16, color: textDim),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 16, color: textDim),
                    const SizedBox(width: 6),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    q.question,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _diffLabel(int d) =>
      d == 1 ? '기본' : d == 2 ? '보통' : '심화';
}
