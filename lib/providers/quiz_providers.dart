import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import 'database_provider.dart';

final questionsForCertProvider =
    FutureProvider.family<List<Question>, String>((ref, certId) async {
  final db = ref.watch(databaseProvider);
  return db.questionDao.getQuestionsByCert(certId);
});

final currentQuestionIndexProvider =
    StateProvider.family<int, String>((ref, certId) => 0);

final answerRevealedProvider =
    StateProvider.family<bool, String>((ref, certId) => false);

/// Live stream so bookmark icon updates immediately after toggle.
final currentQStateProvider =
    StreamProvider.family<QState?, (int, String)>((ref, args) {
  final db = ref.watch(databaseProvider);
  return db.qStateDao.watchState(args.$1, args.$2);
});
