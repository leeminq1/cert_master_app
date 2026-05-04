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

  Future<List<Question>> searchByFts5(String query) async {
    final rows = await customSelect(
      'SELECT id, cert_id, question, answer, ai_explanation, tags, difficulty '
      'FROM questions '
      'WHERE rowid IN (SELECT rowid FROM q_fts WHERE q_fts MATCH ?) '
      'LIMIT 50',
      variables: [Variable(query)],
      readsFrom: {questions},
    ).get();
    return rows
        .map((r) => Question(
              id: r.read<int>('id'),
              certId: r.read<String>('cert_id'),
              question: r.read<String>('question'),
              answer: r.read<String>('answer'),
              aiExplanation: r.read<String>('ai_explanation'),
              tags: r.read<String>('tags'),
              difficulty: r.read<int>('difficulty'),
            ))
        .toList();
  }
}
