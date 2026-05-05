import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';

class MockExamActiveScreen extends ConsumerStatefulWidget {
  final String certId;
  const MockExamActiveScreen({super.key, required this.certId});

  @override
  ConsumerState<MockExamActiveScreen> createState() =>
      _MockExamActiveScreenState();
}

class _MockExamActiveScreenState extends ConsumerState<MockExamActiveScreen> {
  List<Question> _questions = [];
  bool _loading = true;
  int _currentIndex = 0;
  final Map<int, bool> _answers = {};
  bool _revealed = false;
  int _remainingSeconds = 60 * 60;
  int _elapsedSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final qs = await db.questionDao
        .getRandomQuestions(certId: widget.certId, limit: 60);
    setState(() {
      _questions = qs;
      _loading = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        t.cancel();
        _finish();
      } else {
        setState(() {
          _remainingSeconds--;
          _elapsedSeconds++;
        });
      }
    });
  }

  void _grade(bool correct) {
    final q = _questions[_currentIndex];
    setState(() => _answers[q.id] = correct);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _revealed = false;
        });
      } else {
        _finish();
      }
    });
  }

  void _finish() {
    _timer?.cancel();
    final correct = _answers.values.where((v) => v).length;
    context.go(
      '/mock-exam/${widget.certId}/result',
      extra: {
        'correct': correct,
        'total': _questions.length,
        'elapsed': _elapsedSeconds,
      },
    );
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

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
    final timerColor = _remainingSeconds < 5 * 60 ? rose : textDim;

    if (_loading) {
      return Scaffold(backgroundColor: bg, body: const Center(child: CircularProgressIndicator()));
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: text),
          onPressed: () => _showExitDialog(context, text, textDim, lime, surface, border),
        ),
        title: Column(
          children: [
            Text(
              '${_currentIndex + 1} / ${_questions.length}',
              style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w700, color: text),
            ),
            Text(
              '완료 ${_answers.length}문항',
              style: GoogleFonts.notoSansKr(fontSize: 10, color: textDim),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                _fmt(_remainingSeconds),
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 14, fontWeight: FontWeight.w700, color: timerColor),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: lime.withAlpha(30),
            valueColor: AlwaysStoppedAnimation(lime),
            minHeight: 3,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q.',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 12, fontWeight: FontWeight.w700, color: lime)),
                        const SizedBox(height: 8),
                        Text(q.question,
                            style: GoogleFonts.notoSansKr(
                                fontSize: 15, fontWeight: FontWeight.w600, color: text, height: 1.6)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!_revealed)
                    GestureDetector(
                      onTap: () => setState(() => _revealed = true),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: lime.withAlpha(80)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('탭하여 정답 확인',
                              style: GoogleFonts.notoSansKr(
                                  fontSize: 14, color: lime, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    )
                  else
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
                          Text('정답',
                              style: GoogleFonts.notoSansKr(
                                  fontSize: 11, fontWeight: FontWeight.w600, color: lime)),
                          const SizedBox(height: 6),
                          Text(q.answer,
                              style: GoogleFonts.notoSansKr(
                                  fontSize: 14, color: text, height: 1.6)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_revealed)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: _GradeBtn(
                      label: '틀렸어요',
                      icon: Icons.close,
                      color: rose,
                      onTap: () => _grade(false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _GradeBtn(
                      label: '맞았어요',
                      icon: Icons.check,
                      color: lime,
                      onTap: () => _grade(true),
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 24),
        ],
      ),
      ),
    );
  }

  void _showExitDialog(BuildContext ctx, Color text, Color textDim, Color lime,
      Color surface, Color border) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: border)),
        title: Text('모의고사 종료',
            style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700, color: text)),
        content: Text('지금까지 답한 문항으로 결과를 확인할게요.',
            style: GoogleFonts.notoSansKr(fontSize: 14, color: textDim)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('계속하기',
                style: GoogleFonts.notoSansKr(color: textDim)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _finish();
            },
            child: Text('결과 보기',
                style: GoogleFonts.notoSansKr(
                    color: lime, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _GradeBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GradeBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.notoSansKr(
                    fontSize: 14, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
