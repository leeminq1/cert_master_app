import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/cert_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          '자격증 검색',
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
                  hintText: '자격증 이름으로 검색...',
                  hintStyle:
                      GoogleFonts.notoSansKr(fontSize: 15, color: textMute),
                  prefixIcon: Icon(Icons.search, color: textDim),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: textDim, size: 18),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
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
                final filtered = _query.isEmpty
                    ? certs
                    : certs
                        .where((c) => c.certName
                            .toLowerCase()
                            .contains(_query.toLowerCase()))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      '"$_query" 검색 결과가 없습니다.',
                      style: GoogleFonts.notoSansKr(
                          fontSize: 14, color: textDim),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final cert = filtered[i];
                    return GestureDetector(
                      onTap: () => context.push('/cert/${cert.certId}'),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cert.certName,
                                    style: GoogleFonts.notoSansKr(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: text,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    cert.category,
                                    style: GoogleFonts.notoSansKr(
                                      fontSize: 12,
                                      color: textDim,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: lime.withAlpha(25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${cert.totalItems}문항',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: lime,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.chevron_right,
                                color: textDim, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
