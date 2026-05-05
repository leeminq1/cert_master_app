import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'daily_activity_dao.g.dart';

@DriftAccessor(tables: [DailyActivities])
class DailyActivityDao extends DatabaseAccessor<AppDatabase>
    with _$DailyActivityDaoMixin {
  DailyActivityDao(super.db);

  Future<void> upsert(DailyActivitiesCompanion entry) =>
      into(dailyActivities).insertOnConflictUpdate(entry);

  Future<void> incrementActivity(String date, String certId,
      {bool correct = false}) async {
    final existing = await (select(dailyActivities)
          ..where((d) => d.date.equals(date) & d.certId.equals(certId)))
        .getSingleOrNull();

    if (existing == null) {
      await into(dailyActivities).insert(DailyActivitiesCompanion.insert(
        date: date,
        certId: certId,
        count: const Value(1),
        correctCount: Value(correct ? 1 : 0),
      ));
    } else {
      await update(dailyActivities).replace(existing.copyWith(
        count: existing.count + 1,
        correctCount: existing.correctCount + (correct ? 1 : 0),
      ));
    }
  }

  Future<List<String>> getActiveDates() async {
    final result = await customSelect(
      'SELECT DISTINCT date FROM daily_activities ORDER BY date DESC',
      readsFrom: {dailyActivities},
    ).get();
    return result.map((r) => r.read<String>('date')).toList();
  }

  Future<Map<String, int>> getActivityCountByDate() async {
    final result = await customSelect(
      'SELECT date, SUM(count) as total FROM daily_activities GROUP BY date',
      readsFrom: {dailyActivities},
    ).get();
    return {
      for (final r in result) r.read<String>('date'): r.read<int>('total')
    };
  }

  Future<Map<String, (int correct, int total)>> getAccuracyByCert() async {
    final result = await customSelect(
      'SELECT cert_id, SUM(correct_count) as correct, SUM("count") as total '
      'FROM daily_activities GROUP BY cert_id',
      readsFrom: {dailyActivities},
    ).get();
    return {
      for (final r in result)
        r.read<String>('cert_id'): (
          r.read<int>('correct'),
          r.read<int>('total'),
        ),
    };
  }
}
