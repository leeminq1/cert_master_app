import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import 'database_provider.dart';

/// Watches all QStates for a specific cert (live updates on grade changes).
final certQStatesProvider =
    StreamProvider.family<List<QState>, String>((ref, certId) {
  final db = ref.watch(databaseProvider);
  return db.qStateDao.watchAllForCert(certId);
});

/// Consecutive-day streak based on daily_activities.
/// Allows today to be absent (streak persists until you miss a full day).
  final streakProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);
  final dates = await db.dailyActivityDao.getActiveDates();
  if (dates.isEmpty) return 1;

  final dateSet = dates.toSet();
  int streak = 0;
  final now = DateTime.now();

  for (int i = 0; i < 365; i++) {
    final day = DateTime(now.year, now.month, now.day - i);
    final y = day.year;
    final m = day.month.toString().padLeft(2, '0');
    final d = day.day.toString().padLeft(2, '0');
    final dateStr = '$y-$m-$d';

    if (dateSet.contains(dateStr)) {
      streak++;
    } else if (i == 0) {
      // Today not yet practiced — don't break, check yesterday
      continue;
    } else {
      break;
    }
  }
  return streak == 0 ? 1 : streak;
});
