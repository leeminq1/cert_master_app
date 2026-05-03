import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'data/seed/database_seeder.dart';
import 'providers/database_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 서비스 초기화 (timezone 포함)
  await NotificationService.init();

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
