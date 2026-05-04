import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_providers.dart';

class CertMasterApp extends ConsumerWidget {
  const CertMasterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontScaleProvider);
    return MaterialApp.router(
      title: '자격증 마스터',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(
          textScaler: TextScaler.linear(fontScale),
        ),
        child: child!,
      ),
    );
  }
}
