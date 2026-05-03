import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'attempt_dao.g.dart';

@DriftAccessor(tables: [Attempts])
class AttemptDao extends DatabaseAccessor<AppDatabase> with _$AttemptDaoMixin {
  AttemptDao(super.db);

  Future<void> insertAttempt(AttemptsCompanion attempt) =>
      into(attempts).insert(attempt);

  Future<List<Attempt>> getWrongAttempts(String certId) async {
    return customSelect(
      'SELECT a.question_id, a.cert_id, COUNT(*) as wrong_count '
      'FROM attempts a '
      'WHERE a.cert_id = ? AND a.grade = 0 '
      'GROUP BY a.question_id '
      'ORDER BY wrong_count DESC',
      variables: [Variable(certId)],
      readsFrom: {attempts},
    ).map((row) => Attempt(
          id: 0,
          questionId: row.read<int>('question_id'),
          certId: row.read<String>('cert_id'),
          grade: row.read<int>('wrong_count'),
          attemptedAt: DateTime.now(),
        )).get();
  }
}
