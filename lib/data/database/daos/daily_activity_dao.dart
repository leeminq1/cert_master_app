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

  /// Increments count (and optionally correctCount) for the given date/cert.
  Future<void> incrementActivity(String date, String certId,
      {bool correct = false}) async {
    final correctVal = correct ? 1 : 0;
    await customStatement(
      'INSERT INTO daily_activities (date, cert_id, count, correct_count) '
      'VALUES (?, ?, 1, ?) '
      'ON CONFLICT(date, cert_id) DO UPDATE SET '
      'count = count + 1, correct_count = correct_count + ?',
      [date, certId, correctVal, correctVal],
    );
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
}
