import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../data/database/app_database.dart';
import 'package:drift/drift.dart';

class BackupService {
  static Future<void> export(AppDatabase db) async {
    final qStateRows = await db.select(db.qStates).get();
    final attemptRows = await db.select(db.attempts).get();
    final activityRows = await db.select(db.dailyActivities).get();
    final settingRows = await db.select(db.settings).get();

    final data = {
      'version': '1',
      'exported_at': DateTime.now().toIso8601String(),
      'q_states': qStateRows
          .map((r) => {
                'question_id': r.questionId,
                'cert_id': r.certId,
                'ease_factor': r.easeFactor,
                'interval': r.interval,
                'repetitions': r.repetitions,
                'next_review': r.nextReview?.toIso8601String(),
                'mastery_level': r.masteryLevel,
                'bookmarked': r.bookmarked,
              })
          .toList(),
      'attempts': attemptRows
          .map((r) => {
                'id': r.id,
                'question_id': r.questionId,
                'cert_id': r.certId,
                'grade': r.grade,
                'attempted_at': r.attemptedAt.toIso8601String(),
              })
          .toList(),
      'daily_activities': activityRows
          .map((r) => {
                'date': r.date,
                'cert_id': r.certId,
                'count': r.count,
                'correct_count': r.correctCount,
              })
          .toList(),
      'settings': {for (final s in settingRows) s.key: s.value},
    };

    final jsonStr = jsonEncode(data);
    final file = XFile.fromData(
      utf8.encode(jsonStr),
      name:
          'cert_master_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      mimeType: 'application/json',
    );
    await Share.shareXFiles([file]);
  }

  /// Returns null on success, error message on failure.
  static Future<String?> restore(AppDatabase db) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return null;

    try {
      final jsonStr = utf8.decode(result.files.single.bytes!);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (data['version'] != '1') return '지원하지 않는 백업 형식입니다';

      await db.transaction(() async {
        await db.deleteAllUserData();

        for (final r in (data['q_states'] as List)) {
          final m = r as Map<String, dynamic>;
          await db.into(db.qStates).insertOnConflictUpdate(QStatesCompanion.insert(
            questionId: m['question_id'] as int,
            certId: m['cert_id'] as String,
            easeFactor: Value(m['ease_factor'] as double),
            interval: Value(m['interval'] as int),
            repetitions: Value(m['repetitions'] as int),
            nextReview: Value(m['next_review'] != null
                ? DateTime.parse(m['next_review'] as String)
                : null),
            masteryLevel: Value(m['mastery_level'] as int),
            bookmarked: Value(m['bookmarked'] as bool),
          ));
        }

        for (final r in (data['attempts'] as List)) {
          final m = r as Map<String, dynamic>;
          await db.into(db.attempts).insert(AttemptsCompanion.insert(
            questionId: m['question_id'] as int,
            certId: m['cert_id'] as String,
            grade: m['grade'] as int,
            attemptedAt: DateTime.parse(m['attempted_at'] as String),
          ));
        }

        for (final r in (data['daily_activities'] as List)) {
          final m = r as Map<String, dynamic>;
          await db.into(db.dailyActivities).insertOnConflictUpdate(
            DailyActivitiesCompanion.insert(
              date: m['date'] as String,
              certId: m['cert_id'] as String,
              count: Value(m['count'] as int),
              correctCount: Value(m['correct_count'] as int),
            ),
          );
        }

        for (final entry
            in (data['settings'] as Map<String, dynamic>).entries) {
          await db.settingsDao.set(entry.key, entry.value.toString());
        }
      });
      return null;
    } catch (e) {
      return '복원 실패: $e';
    }
  }
}
