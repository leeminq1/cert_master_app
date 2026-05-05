import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/database_provider.dart';

class OneMinCoreScreen extends ConsumerStatefulWidget {
  final String certId;
  const OneMinCoreScreen({super.key, required this.certId});

  @override
  ConsumerState<OneMinCoreScreen> createState() => _OneMinCoreScreenState();
}

class _OneMinCoreScreenState extends ConsumerState<OneMinCoreScreen> {
  List<_CardData> _cards = [];
  bool _loading = true;
  int _index = 0;
  late PageController _pageController;
  Timer? _autoTimer;
  double _autoProgress = 0;
  static const _intervalMs = 7000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadCards();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final db = ref.read(databaseProvider);
    final questions = await db.questionDao.getQuestionsByCert(widget.certId);
    final cards = <_CardData>[];
    for (final q in questions) {
      Map<String, dynamic> exp = {};
      try {
        exp = jsonDecode(q.aiExplanation) as Map<String, dynamic>;
      } catch (_) {}
      final concept = exp['concept'] as String? ?? '';
      final memTip = exp['memory_tip'] as String? ?? '';
      if (concept.isNotEmpty) {
        cards.add(_CardData(question: q.question, concept: concept, memoryTip: memTip));
      }
    }
    cards.shuffle();
    setState(() {
      _cards = cards.take(10).toList();
      _loading = false;
    });
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoTimer?.cancel();
    setState(() => _autoProgress = 0.0);
    const tickMs = 50;
    _autoTimer = Timer.periodic(const Duration(milliseconds: tickMs), (t) {
      final next = _autoProgress + tickMs / _intervalMs;
      if (next >= 1.0) {
        t.cancel();
        if (_index < _cards.length - 1) _goTo(_index + 1);
      } else {
        setState(() => _autoProgress = next);
      }
    });
  }

  void _goTo(int idx) {
    setState(() => _index = idx);
    _pageController.animateToPage(idx,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    _startAutoAdvance();
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
          '1분 핵심',
          style: GoogleFonts.notoSansKr(fontSize: 16, fontWeight: FontWeight.w700, color: text),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _cards.isEmpty
              ? Center(
                  child: Text('AI 해설 데이터가 없습니다',
                      style: GoogleFonts.notoSansKr(color: textDim)),
                )
              : SafeArea(
                  child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: _autoProgress,
                      backgroundColor: lime.withAlpha(30),
                      valueColor: AlwaysStoppedAnimation(lime),
                      minHeight: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_index + 1} / ${_cards.length}',
                            style: GoogleFonts.jetBrainsMono(fontSize: 12, color: textDim),
                          ),
                          Row(
                            children: List.generate(
                              _cards.length,
                              (i) => Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i == _index ? lime : lime.withAlpha(60),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (idx) {
                          setState(() => _index = idx);
                          _startAutoAdvance();
                        },
                        itemCount: _cards.length,
                        itemBuilder: (_, i) => _CoreCard(
                          card: _cards[i],
                          isDark: isDark,
                          surface: surface,
                          border: border,
                          text: text,
                          textDim: textDim,
                          lime: lime,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: _NavBtn(
                              label: '이전',
                              icon: Icons.arrow_back_ios_new_rounded,
                              enabled: _index > 0,
                              isNext: false,
                              onTap: () => _goTo(_index - 1),
                              lime: lime,
                              textDim: textDim,
                              surface: surface,
                              border: border,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _index < _cards.length - 1
                                ? _NavBtn(
                                    label: '다음',
                                    icon: Icons.arrow_forward_ios_rounded,
                                    enabled: true,
                                    isNext: true,
                                    onTap: () => _goTo(_index + 1),
                                    lime: lime,
                                    textDim: textDim,
                                    surface: surface,
                                    border: border,
                                    isDark: isDark,
                                  )
                                : GestureDetector(
                                    onTap: () => context.pop(),
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: lime,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '완료',
                                          style: GoogleFonts.notoSansKr(
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? AppColors.darkBg : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
    );
  }
}

class _CardData {
  final String question;
  final String concept;
  final String memoryTip;
  const _CardData({required this.question, required this.concept, required this.memoryTip});
}

class _CoreCard extends StatelessWidget {
  final _CardData card;
  final bool isDark;
  final Color surface, border, text, textDim, lime;

  const _CoreCard({
    required this.card,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.text,
    required this.textDim,
    required this.lime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: lime.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '개념',
                  style: GoogleFonts.notoSansKr(fontSize: 11, fontWeight: FontWeight.w500, color: lime),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                card.question,
                style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w600, color: text),
              ),
              const SizedBox(height: 16),
              Divider(color: border, height: 1),
              const SizedBox(height: 16),
              Text(
                '핵심 요약',
                style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: textDim),
              ),
              const SizedBox(height: 6),
              Text(
                card.concept,
                style: GoogleFonts.notoSansKr(fontSize: 14, color: text, height: 1.6),
              ),
              if (card.memoryTip.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '암기 팁',
                  style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: textDim),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: lime.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: lime.withAlpha(60)),
                  ),
                  child: Text(
                    card.memoryTip,
                    style: GoogleFonts.notoSansKr(fontSize: 13, color: text, height: 1.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final bool isNext;
  final bool isDark;
  final VoidCallback onTap;
  final Color lime, textDim, surface, border;

  const _NavBtn({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.isNext,
    required this.isDark,
    required this.onTap,
    required this.lime,
    required this.textDim,
    required this.surface,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isNext && enabled ? lime : surface;
    final activeBorder = isNext && enabled ? lime : border;
    final labelColor = isNext && enabled ? (isDark ? AppColors.darkBg : Colors.white) : textDim;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.3,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: activeBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: isNext
                ? [
                    Text(label,
                        style: GoogleFonts.notoSansKr(
                            fontWeight: FontWeight.w600, color: labelColor)),
                    const SizedBox(width: 4),
                    Icon(icon, size: 14, color: labelColor),
                  ]
                : [
                    Icon(icon, size: 14, color: labelColor),
                    const SizedBox(width: 4),
                    Text(label,
                        style: GoogleFonts.notoSansKr(
                            fontWeight: FontWeight.w600, color: labelColor)),
                  ],
          ),
        ),
      ),
    );
  }
}
