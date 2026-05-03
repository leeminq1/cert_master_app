import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

class AiExplanationJson {
  final String background;
  final String concept;
  final String examTip;
  final String memoryTip;

  const AiExplanationJson({
    required this.background,
    required this.concept,
    required this.examTip,
    required this.memoryTip,
  });

  factory AiExplanationJson.fromJson(Map<String, dynamic> j) =>
      AiExplanationJson(
        background: j['background'] as String? ?? '',
        concept: j['concept'] as String? ?? '',
        examTip: j['exam_tip'] as String? ?? '',
        memoryTip: j['memory_tip'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'background': background,
        'concept': concept,
        'exam_tip': examTip,
        'memory_tip': memoryTip,
      };
}

AiExplanationJson? _parseAiExplanation(dynamic raw) {
  if (raw == null) return null;
  if (raw is Map<String, dynamic>) return AiExplanationJson.fromJson(raw);
  if (raw is String && raw.isNotEmpty) {
    try {
      return AiExplanationJson.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {}
  }
  return null;
}

class QuestionJson {
  final int id;
  final String question;
  final String answer;
  final AiExplanationJson? aiExplanation;
  final List<String> tags;
  final int difficulty;

  const QuestionJson({
    required this.id,
    required this.question,
    required this.answer,
    this.aiExplanation,
    required this.tags,
    required this.difficulty,
  });

  factory QuestionJson.fromJson(Map<String, dynamic> j) => QuestionJson(
        id: j['id'] as int,
        question: j['question'] as String? ?? '',
        answer: j['answer'] as String? ?? '',
        aiExplanation: _parseAiExplanation(j['ai_explanation']),
        tags: (j['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        difficulty: j['difficulty'] as int? ?? 1,
      );

  QuestionsCompanion toCompanion(String certId) => QuestionsCompanion(
        id: Value(id),
        certId: Value(certId),
        question: Value(question),
        answer: Value(answer),
        aiExplanation: Value(
            aiExplanation != null ? jsonEncode(aiExplanation!.toJson()) : '{}'),
        tags: Value(jsonEncode(tags)),
        difficulty: Value(difficulty),
      );
}

class CertJson {
  final String certId;
  final String certName;
  final String category;
  final int totalItems;
  final List<QuestionJson> items;

  const CertJson({
    required this.certId,
    required this.certName,
    required this.category,
    required this.totalItems,
    required this.items,
  });

  factory CertJson.fromJson(Map<String, dynamic> j) => CertJson(
        certId: j['cert_id'] as String,
        certName: j['cert_name'] as String,
        category: j['category'] as String,
        totalItems: j['total_items'] as int,
        items: (j['items'] as List<dynamic>)
            .map((e) => QuestionJson.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  CertsCompanion toCompanion() => CertsCompanion(
        certId: Value(certId),
        certName: Value(certName),
        category: Value(category),
        totalItems: Value(totalItems),
      );
}
