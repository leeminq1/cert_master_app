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
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'cert_master.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
