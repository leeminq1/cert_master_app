import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'question_dao.g.dart';

@DriftAccessor(tables: [Questions])
class QuestionDao extends DatabaseAccessor<AppDatabase>
    with _$QuestionDaoMixin {
  QuestionDao(super.db);

  Future<List<Question>> getQuestionsByCert(String certId) =>
      (select(questions)..where((t) => t.certId.equals(certId))).get();

  Future<Question?> getQuestionById(int id, String certId) =>
      (select(questions)
            ..where((t) => t.id.equals(id) & t.certId.equals(certId)))
          .getSingleOrNull();

  Future<List<Question>> getRandomQuestions(
      {required String certId, int limit = 60}) async {
    return (select(questions)
          ..where((t) => t.certId.equals(certId))
          ..orderBy([(t) => OrderingTerm.random()])
          ..limit(limit))
        .get();
  }

  Future<void> insertQuestions(List<QuestionsCompanion> rows) async {
    await batch((b) => b.insertAllOnConflictUpdate(questions, rows));
  }
}
