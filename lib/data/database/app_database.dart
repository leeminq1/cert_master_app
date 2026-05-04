import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables.dart';
import 'daos/cert_dao.dart';
import 'daos/question_dao.dart';
import 'daos/q_state_dao.dart';
import 'daos/attempt_dao.dart';
import 'daos/daily_activity_dao.dart';
import 'daos/settings_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Certs, Questions, QStates, Attempts, DailyActivities, Settings],
  daos: [CertDao, QuestionDao, QStateDao, AttemptDao, DailyActivityDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createFts5();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) await _createFts5();
    },
  );

  Future<void> _createFts5() async {
    await customStatement(
      "CREATE VIRTUAL TABLE IF NOT EXISTS q_fts USING fts5("
      "question, answer, content='questions', content_rowid='rowid')",
    );
    await customStatement("INSERT INTO q_fts(q_fts) VALUES ('rebuild')");
  }

  Future<void> deleteAllUserData() async {
    await delete(qStates).go();
    await delete(attempts).go();
    await delete(dailyActivities).go();
    await (delete(settings)
          ..where((s) => s.key.isNotIn([
                'theme_mode',
                'notification_enabled',
                'daily_hour',
                'daily_minute',
                'daily_enabled',
              ])))
        .go();
  }

  Future<void> deleteUserDataForCert(String certId) async {
    await (delete(qStates)..where((q) => q.certId.equals(certId))).go();
    await (delete(attempts)..where((a) => a.certId.equals(certId))).go();
    await (delete(dailyActivities)..where((d) => d.certId.equals(certId))).go();
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'cert_master.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
