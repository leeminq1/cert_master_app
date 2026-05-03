import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'q_state_dao.g.dart';

@DriftAccessor(tables: [QStates])
class QStateDao extends DatabaseAccessor<AppDatabase> with _$QStateDaoMixin {
  QStateDao(super.db);

  Future<QState?> getState(int questionId, String certId) =>
      (select(qStates)
            ..where(
                (t) => t.questionId.equals(questionId) & t.certId.equals(certId)))
          .getSingleOrNull();

  Stream<QState?> watchState(int questionId, String certId) =>
      (select(qStates)
            ..where(
                (t) => t.questionId.equals(questionId) & t.certId.equals(certId)))
          .watchSingleOrNull();

  Stream<List<QState>> watchAllForCert(String certId) =>
      (select(qStates)..where((t) => t.certId.equals(certId))).watch();

  Future<void> upsertState(QStatesCompanion state) =>
      into(qStates).insertOnConflictUpdate(state);

  Future<int> countCompletedByCert(String certId) async {
    final result = await customSelect(
      'SELECT COUNT(*) as c FROM q_states WHERE cert_id = ? AND mastery_level > 0',
      variables: [Variable(certId)],
      readsFrom: {qStates},
    ).getSingle();
    return result.read<int>('c');
  }

  Stream<List<QState>> watchBookmarked(String certId) =>
      (select(qStates)
            ..where((t) => t.certId.equals(certId) & t.bookmarked.equals(true)))
          .watch();

  Future<void> toggleBookmark(int questionId, String certId, bool value) =>
      (update(qStates)
            ..where(
                (t) => t.questionId.equals(questionId) & t.certId.equals(certId)))
          .write(QStatesCompanion(bookmarked: Value(value)));
}
