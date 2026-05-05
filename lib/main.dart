import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app.dart';
import 'data/seed/database_seeder.dart';
import 'providers/database_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 서비스 초기화 (timezone 포함)
  await NotificationService.init();

  // AdMob 초기화 (백그라운드 — await 불필요, 광고 로드 전 완료됨)
  MobileAds.instance.initialize();

  final container = ProviderContainer();
  final db = container.read(databaseProvider);
  await seedIfEmpty(db);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CertMasterApp(),
    ),
  );
}
