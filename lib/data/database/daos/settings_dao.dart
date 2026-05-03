import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<String?> get(String key) async {
    final row = await (select(settings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String value) =>
      into(settings).insertOnConflictUpdate(
        SettingsCompanion(key: Value(key), value: Value(value)),
      );

  Future<int> getLastQuizIndex(String certId) async {
    final val = await get('quiz_last_index_$certId');
    return val == null ? 0 : (int.tryParse(val) ?? 0);
  }

  Future<void> setLastQuizIndex(String certId, int index) =>
      set('quiz_last_index_$certId', index.toString());
}
