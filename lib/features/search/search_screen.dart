import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import '../../providers/cert_providers.dart';
import '../../providers/database_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  List<Question> _questionResults = [];
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String v) {
    final q = v.trim();
    setState(() {
      _query = q;
      if (q.length < 2) _questionResults = [];
    });
    if (q.length < 2) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final db = ref.read(databaseProvider);
      try {
        final results = await db.questionDao.searchByFts5(q);
        if (mounted && _query == q) {
          setState(() => _questionResults = results);
        }
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final certsAsync = ref.watch(allCertsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surface2 =
        isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;
    final textMute =
        isDark ? AppColors.darkTextMute : AppColors.lightTextMute;
    final lime = isDark ? AppColors.darkLime : AppColors.lightLime;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(
          '검색',
          style: GoogleFonts.notoSansKr(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Container(
              decoration: BoxDecoration(
                color: surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                style: GoogleFonts.notoSansKr(fontSize: 15, color: text),
                decoration: InputDecoration(
                  hintText: '자격증 또는 문항 검색...',
                  hintStyle:
                      GoogleFonts.notoSansKr(fontSize: 15, color: textMute),
                  prefixIcon: Icon(Icons.search, color: textDim),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: textDim, size: 18),
                          onPressed: () {
                            _controller.clear();
                            _onQueryChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: _onQueryChanged,
              ),
            ),
          ),

          // 결과 목록
          Expanded(
            child: certsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('오류: $e')),
              data: (certs) {
                final filteredCerts = _query.isEmpty
                    ? certs
                    : certs
                        .where((c) => c.certName
                            .toLowerCase()
                            .contains(_query.toLowerCase()))
                        .toList();

                final hasCerts = filteredCerts.isNotEmpty;
                final hasQuestions =
                    _query.length >= 2 && _questionResults.isNotEmpty;

                if (!hasCerts && !hasQuestions && _query.isNotEmpty) {
                  return Center(
                    child: Text(
                      '"$_query" 검색 결과가 없습니다.',
                      style: GoogleFonts.notoSansKr(
                          fontSize: 14, color: textDim),
                    ),
                  );
                }

                // Cert lookup map for question results
                final certMap = {for (final c in certs) c.certId: c};

                return ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  children: [
                    // 자격증 결과
                    if (hasCerts) ...[
                      if (_query.isNotEmpty)
                        _SectionLabel(
                            label: '자격증',
                            textDim: textDim),
                      for (final cert in filteredCerts)
                        _CertTile(
                          cert: cert,
                          lime: lime,
                          surface: surface,
                          border: border,
                          text: text,
                          textDim: textDim,
                          onTap: () =>
                              context.push('/cert/${cert.certId}'),
                        ),
                    ],

                    // 문항 결과
                    if (hasQuestions) ...[
                      const SizedBox(height: 8),
                      _SectionLabel(label: '문항', textDim: textDim),
                      for (final q in _questionResults)
                        _QuestionTile(
                          question: q,
                          certName: certMap[q.certId]?.certName ?? q.certId,
                          category: certMap[q.certId]?.category ?? '',
                          lime: lime,
                          surface: surface,
                          border: border,
                          text: text,
                          textDim: textDim,
                          onTap: () => context.push(
                            '/cert/${q.certId}/explanation'
                            '?questionId=${q.id}',
                            extra: false,
                          ),
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color textDim;
  const _SectionLabel({required this.label, required this.textDim});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 6, top: 4),
        child: Text(label,
            style: GoogleFonts.notoSansKr(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textDim,
                letterSpacing: 0.5)),
      );
}

class _CertTile extends StatelessWidget {
  final Cert cert;
  final Color lime;
  final Color surface;
  final Color border;
  final Color text;
  final Color textDim;
  final VoidCallback onTap;

  const _CertTile({
    required this.cert,
    required this.lime,
    required this.surface,
    required this.border,
    required this.text,
    required this.textDim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cert.certName,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: text,
                      )),
                  const SizedBox(height: 4),
                  Text(cert.category,
                      style: GoogleFonts.notoSansKr(
                          fontSize: 12, color: textDim)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: lime.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${cert.totalItems}문항',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: lime),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: textDim, size: 18),
          ],
        ),
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final Question question;
  final String certName;
  final String category;
  final Color lime;
  final Color surface;
  final Color border;
  final Color text;
  final Color textDim;
  final VoidCallback onTap;

  const _QuestionTile({
    required this.question,
    required this.certName,
    required this.category,
    required this.lime,
    required this.surface,
    required this.border,
    required this.text,
    required this.textDim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: GoogleFonts.notoSansKr(
                  fontSize: 13, color: text, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: lime.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(certName,
                      style: GoogleFonts.notoSansKr(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: lime)),
                ),
                if (category.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(category,
                      style: GoogleFonts.notoSansKr(
                          fontSize: 10, color: textDim)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
