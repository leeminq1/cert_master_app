// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CertsTable extends Certs with TableInfo<$CertsTable, Cert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _certIdMeta = const VerificationMeta('certId');
  @override
  late final GeneratedColumn<String> certId = GeneratedColumn<String>(
      'cert_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _certNameMeta =
      const VerificationMeta('certName');
  @override
  late final GeneratedColumn<String> certName = GeneratedColumn<String>(
      'cert_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalItemsMeta =
      const VerificationMeta('totalItems');
  @override
  late final GeneratedColumn<int> totalItems = GeneratedColumn<int>(
      'total_items', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1.0'));
  @override
  List<GeneratedColumn> get $columns =>
      [certId, certName, category, totalItems, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'certs';
  @override
  VerificationContext validateIntegrity(Insertable<Cert> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cert_id')) {
      context.handle(_certIdMeta,
          certId.isAcceptableOrUnknown(data['cert_id']!, _certIdMeta));
    } else if (isInserting) {
      context.missing(_certIdMeta);
    }
    if (data.containsKey('cert_name')) {
      context.handle(_certNameMeta,
          certName.isAcceptableOrUnknown(data['cert_name']!, _certNameMeta));
    } else if (isInserting) {
      context.missing(_certNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('total_items')) {
      context.handle(
          _totalItemsMeta,
          totalItems.isAcceptableOrUnknown(
              data['total_items']!, _totalItemsMeta));
    } else if (isInserting) {
      context.missing(_totalItemsMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {certId};
  @override
  Cert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cert(
      certId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cert_id'])!,
      certName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cert_name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      totalItems: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_items'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $CertsTable createAlias(String alias) {
    return $CertsTable(attachedDatabase, alias);
  }
}

class Cert extends DataClass implements Insertable<Cert> {
  final String certId;
  final String certName;
  final String category;
  final int totalItems;
  final String version;
  const Cert(
      {required this.certId,
      required this.certName,
      required this.category,
      required this.totalItems,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cert_id'] = Variable<String>(certId);
    map['cert_name'] = Variable<String>(certName);
    map['category'] = Variable<String>(category);
    map['total_items'] = Variable<int>(totalItems);
    map['version'] = Variable<String>(version);
    return map;
  }

  CertsCompanion toCompanion(bool nullToAbsent) {
    return CertsCompanion(
      certId: Value(certId),
      certName: Value(certName),
      category: Value(category),
      totalItems: Value(totalItems),
      version: Value(version),
    );
  }

  factory Cert.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cert(
      certId: serializer.fromJson<String>(json['certId']),
      certName: serializer.fromJson<String>(json['certName']),
      category: serializer.fromJson<String>(json['category']),
      totalItems: serializer.fromJson<int>(json['totalItems']),
      version: serializer.fromJson<String>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'certId': serializer.toJson<String>(certId),
      'certName': serializer.toJson<String>(certName),
      'category': serializer.toJson<String>(category),
      'totalItems': serializer.toJson<int>(totalItems),
      'version': serializer.toJson<String>(version),
    };
  }

  Cert copyWith(
          {String? certId,
          String? certName,
          String? category,
          int? totalItems,
          String? version}) =>
      Cert(
        certId: certId ?? this.certId,
        certName: certName ?? this.certName,
        category: category ?? this.category,
        totalItems: totalItems ?? this.totalItems,
        version: version ?? this.version,
      );
  Cert copyWithCompanion(CertsCompanion data) {
    return Cert(
      certId: data.certId.present ? data.certId.value : this.certId,
      certName: data.certName.present ? data.certName.value : this.certName,
      category: data.category.present ? data.category.value : this.category,
      totalItems:
          data.totalItems.present ? data.totalItems.value : this.totalItems,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cert(')
          ..write('certId: $certId, ')
          ..write('certName: $certName, ')
          ..write('category: $category, ')
          ..write('totalItems: $totalItems, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(certId, certName, category, totalItems, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cert &&
          other.certId == this.certId &&
          other.certName == this.certName &&
          other.category == this.category &&
          other.totalItems == this.totalItems &&
          other.version == this.version);
}

class CertsCompanion extends UpdateCompanion<Cert> {
  final Value<String> certId;
  final Value<String> certName;
  final Value<String> category;
  final Value<int> totalItems;
  final Value<String> version;
  final Value<int> rowid;
  const CertsCompanion({
    this.certId = const Value.absent(),
    this.certName = const Value.absent(),
    this.category = const Value.absent(),
    this.totalItems = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CertsCompanion.insert({
    required String certId,
    required String certName,
    required String category,
    required int totalItems,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : certId = Value(certId),
        certName = Value(certName),
        category = Value(category),
        totalItems = Value(totalItems);
  static Insertable<Cert> custom({
    Expression<String>? certId,
    Expression<String>? certName,
    Expression<String>? category,
    Expression<int>? totalItems,
    Expression<String>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (certId != null) 'cert_id': certId,
      if (certName != null) 'cert_name': certName,
      if (category != null) 'category': category,
      if (totalItems != null) 'total_items': totalItems,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CertsCompanion copyWith(
      {Value<String>? certId,
      Value<String>? certName,
      Value<String>? category,
      Value<int>? totalItems,
      Value<String>? version,
      Value<int>? rowid}) {
    return CertsCompanion(
      certId: certId ?? this.certId,
      certName: certName ?? this.certName,
      category: category ?? this.category,
      totalItems: totalItems ?? this.totalItems,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (certId.present) {
      map['cert_id'] = Variable<String>(certId.value);
    }
    if (certName.present) {
      map['cert_name'] = Variable<String>(certName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (totalItems.present) {
      map['total_items'] = Variable<int>(totalItems.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CertsCompanion(')
          ..write('certId: $certId, ')
          ..write('certName: $certName, ')
          ..write('category: $category, ')
          ..write('totalItems: $totalItems, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _certIdMeta = const VerificationMeta('certId');
  @override
  late final GeneratedColumn<String> certId = GeneratedColumn<String>(
      'cert_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aiExplanationMeta =
      const VerificationMeta('aiExplanation');
  @override
  late final GeneratedColumn<String> aiExplanation = GeneratedColumn<String>(
      'ai_explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, certId, question, answer, aiExplanation, tags, difficulty];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(Insertable<Question> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cert_id')) {
      context.handle(_certIdMeta,
          certId.isAcceptableOrUnknown(data['cert_id']!, _certIdMeta));
    } else if (isInserting) {
      context.missing(_certIdMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('ai_explanation')) {
      context.handle(
          _aiExplanationMeta,
          aiExplanation.isAcceptableOrUnknown(
              data['ai_explanation']!, _aiExplanationMeta));
    } else if (isInserting) {
      context.missing(_aiExplanationMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, certId};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      certId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cert_id'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      aiExplanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ai_explanation'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}difficulty'])!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final int id;
  final String certId;
  final String question;
  final String answer;
  final String aiExplanation;
  final String tags;
  final int difficulty;
  const Question(
      {required this.id,
      required this.certId,
      required this.question,
      required this.answer,
      required this.aiExplanation,
      required this.tags,
      required this.difficulty});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cert_id'] = Variable<String>(certId);
    map['question'] = Variable<String>(question);
    map['answer'] = Variable<String>(answer);
    map['ai_explanation'] = Variable<String>(aiExplanation);
    map['tags'] = Variable<String>(tags);
    map['difficulty'] = Variable<int>(difficulty);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      certId: Value(certId),
      question: Value(question),
      answer: Value(answer),
      aiExplanation: Value(aiExplanation),
      tags: Value(tags),
      difficulty: Value(difficulty),
    );
  }

  factory Question.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<int>(json['id']),
      certId: serializer.fromJson<String>(json['certId']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String>(json['answer']),
      aiExplanation: serializer.fromJson<String>(json['aiExplanation']),
      tags: serializer.fromJson<String>(json['tags']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'certId': serializer.toJson<String>(certId),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String>(answer),
      'aiExplanation': serializer.toJson<String>(aiExplanation),
      'tags': serializer.toJson<String>(tags),
      'difficulty': serializer.toJson<int>(difficulty),
    };
  }

  Question copyWith(
          {int? id,
          String? certId,
          String? question,
          String? answer,
          String? aiExplanation,
          String? tags,
          int? difficulty}) =>
      Question(
        id: id ?? this.id,
        certId: certId ?? this.certId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        aiExplanation: aiExplanation ?? this.aiExplanation,
        tags: tags ?? this.tags,
        difficulty: difficulty ?? this.difficulty,
      );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      certId: data.certId.present ? data.certId.value : this.certId,
      question: data.question.present ? data.question.value : this.question,
      answer: data.answer.present ? data.answer.value : this.answer,
      aiExplanation: data.aiExplanation.present
          ? data.aiExplanation.value
          : this.aiExplanation,
      tags: data.tags.present ? data.tags.value : this.tags,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('certId: $certId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('aiExplanation: $aiExplanation, ')
          ..write('tags: $tags, ')
          ..write('difficulty: $difficulty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, certId, question, answer, aiExplanation, tags, difficulty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.certId == this.certId &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.aiExplanation == this.aiExplanation &&
          other.tags == this.tags &&
          other.difficulty == this.difficulty);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<int> id;
  final Value<String> certId;
  final Value<String> question;
  final Value<String> answer;
  final Value<String> aiExplanation;
  final Value<String> tags;
  final Value<int> difficulty;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.certId = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.aiExplanation = const Value.absent(),
    this.tags = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required int id,
    required String certId,
    required String question,
    required String answer,
    required String aiExplanation,
    this.tags = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        certId = Value(certId),
        question = Value(question),
        answer = Value(answer),
        aiExplanation = Value(aiExplanation);
  static Insertable<Question> custom({
    Expression<int>? id,
    Expression<String>? certId,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<String>? aiExplanation,
    Expression<String>? tags,
    Expression<int>? difficulty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (certId != null) 'cert_id': certId,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (aiExplanation != null) 'ai_explanation': aiExplanation,
      if (tags != null) 'tags': tags,
      if (difficulty != null) 'difficulty': difficulty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? certId,
      Value<String>? question,
      Value<String>? answer,
      Value<String>? aiExplanation,
      Value<String>? tags,
      Value<int>? difficulty,
      Value<int>? rowid}) {
    return QuestionsCompanion(
      id: id ?? this.id,
      certId: certId ?? this.certId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      aiExplanation: aiExplanation ?? this.aiExplanation,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (certId.present) {
      map['cert_id'] = Variable<String>(certId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (aiExplanation.present) {
      map['ai_explanation'] = Variable<String>(aiExplanation.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('certId: $certId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('aiExplanation: $aiExplanation, ')
          ..write('tags: $tags, ')
          ..write('difficulty: $difficulty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QStatesTable extends QStates with TableInfo<$QStatesTable, QState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
      'question_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _certIdMeta = const VerificationMeta('certId');
  @override
  late final GeneratedColumn<String> certId = GeneratedColumn<String>(
      'cert_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _intervalMeta =
      const VerificationMeta('interval');
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
      'interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _repetitionsMeta =
      const VerificationMeta('repetitions');
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
      'repetitions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextReviewMeta =
      const VerificationMeta('nextReview');
  @override
  late final GeneratedColumn<DateTime> nextReview = GeneratedColumn<DateTime>(
      'next_review', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _masteryLevelMeta =
      const VerificationMeta('masteryLevel');
  @override
  late final GeneratedColumn<int> masteryLevel = GeneratedColumn<int>(
      'mastery_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _bookmarkedMeta =
      const VerificationMeta('bookmarked');
  @override
  late final GeneratedColumn<bool> bookmarked = GeneratedColumn<bool>(
      'bookmarked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("bookmarked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        questionId,
        certId,
        easeFactor,
        interval,
        repetitions,
        nextReview,
        masteryLevel,
        bookmarked
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'q_states';
  @override
  VerificationContext validateIntegrity(Insertable<QState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('cert_id')) {
      context.handle(_certIdMeta,
          certId.isAcceptableOrUnknown(data['cert_id']!, _certIdMeta));
    } else if (isInserting) {
      context.missing(_certIdMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('interval')) {
      context.handle(_intervalMeta,
          interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta));
    }
    if (data.containsKey('repetitions')) {
      context.handle(
          _repetitionsMeta,
          repetitions.isAcceptableOrUnknown(
              data['repetitions']!, _repetitionsMeta));
    }
    if (data.containsKey('next_review')) {
      context.handle(
          _nextReviewMeta,
          nextReview.isAcceptableOrUnknown(
              data['next_review']!, _nextReviewMeta));
    }
    if (data.containsKey('mastery_level')) {
      context.handle(
          _masteryLevelMeta,
          masteryLevel.isAcceptableOrUnknown(
              data['mastery_level']!, _masteryLevelMeta));
    }
    if (data.containsKey('bookmarked')) {
      context.handle(
          _bookmarkedMeta,
          bookmarked.isAcceptableOrUnknown(
              data['bookmarked']!, _bookmarkedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId, certId};
  @override
  QState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QState(
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}question_id'])!,
      certId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cert_id'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      interval: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval'])!,
      repetitions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetitions'])!,
      nextReview: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_review']),
      masteryLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mastery_level'])!,
      bookmarked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}bookmarked'])!,
    );
  }

  @override
  $QStatesTable createAlias(String alias) {
    return $QStatesTable(attachedDatabase, alias);
  }
}

class QState extends DataClass implements Insertable<QState> {
  final int questionId;
  final String certId;
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime? nextReview;
  final int masteryLevel;
  final bool bookmarked;
  const QState(
      {required this.questionId,
      required this.certId,
      required this.easeFactor,
      required this.interval,
      required this.repetitions,
      this.nextReview,
      required this.masteryLevel,
      required this.bookmarked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<int>(questionId);
    map['cert_id'] = Variable<String>(certId);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval'] = Variable<int>(interval);
    map['repetitions'] = Variable<int>(repetitions);
    if (!nullToAbsent || nextReview != null) {
      map['next_review'] = Variable<DateTime>(nextReview);
    }
    map['mastery_level'] = Variable<int>(masteryLevel);
    map['bookmarked'] = Variable<bool>(bookmarked);
    return map;
  }

  QStatesCompanion toCompanion(bool nullToAbsent) {
    return QStatesCompanion(
      questionId: Value(questionId),
      certId: Value(certId),
      easeFactor: Value(easeFactor),
      interval: Value(interval),
      repetitions: Value(repetitions),
      nextReview: nextReview == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReview),
      masteryLevel: Value(masteryLevel),
      bookmarked: Value(bookmarked),
    );
  }

  factory QState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QState(
      questionId: serializer.fromJson<int>(json['questionId']),
      certId: serializer.fromJson<String>(json['certId']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      interval: serializer.fromJson<int>(json['interval']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      nextReview: serializer.fromJson<DateTime?>(json['nextReview']),
      masteryLevel: serializer.fromJson<int>(json['masteryLevel']),
      bookmarked: serializer.fromJson<bool>(json['bookmarked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<int>(questionId),
      'certId': serializer.toJson<String>(certId),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'interval': serializer.toJson<int>(interval),
      'repetitions': serializer.toJson<int>(repetitions),
      'nextReview': serializer.toJson<DateTime?>(nextReview),
      'masteryLevel': serializer.toJson<int>(masteryLevel),
      'bookmarked': serializer.toJson<bool>(bookmarked),
    };
  }

  QState copyWith(
          {int? questionId,
          String? certId,
          double? easeFactor,
          int? interval,
          int? repetitions,
          Value<DateTime?> nextReview = const Value.absent(),
          int? masteryLevel,
          bool? bookmarked}) =>
      QState(
        questionId: questionId ?? this.questionId,
        certId: certId ?? this.certId,
        easeFactor: easeFactor ?? this.easeFactor,
        interval: interval ?? this.interval,
        repetitions: repetitions ?? this.repetitions,
        nextReview: nextReview.present ? nextReview.value : this.nextReview,
        masteryLevel: masteryLevel ?? this.masteryLevel,
        bookmarked: bookmarked ?? this.bookmarked,
      );
  QState copyWithCompanion(QStatesCompanion data) {
    return QState(
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      certId: data.certId.present ? data.certId.value : this.certId,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      interval: data.interval.present ? data.interval.value : this.interval,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
      nextReview:
          data.nextReview.present ? data.nextReview.value : this.nextReview,
      masteryLevel: data.masteryLevel.present
          ? data.masteryLevel.value
          : this.masteryLevel,
      bookmarked:
          data.bookmarked.present ? data.bookmarked.value : this.bookmarked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QState(')
          ..write('questionId: $questionId, ')
          ..write('certId: $certId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('interval: $interval, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReview: $nextReview, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('bookmarked: $bookmarked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questionId, certId, easeFactor, interval,
      repetitions, nextReview, masteryLevel, bookmarked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QState &&
          other.questionId == this.questionId &&
          other.certId == this.certId &&
          other.easeFactor == this.easeFactor &&
          other.interval == this.interval &&
          other.repetitions == this.repetitions &&
          other.nextReview == this.nextReview &&
          other.masteryLevel == this.masteryLevel &&
          other.bookmarked == this.bookmarked);
}

class QStatesCompanion extends UpdateCompanion<QState> {
  final Value<int> questionId;
  final Value<String> certId;
  final Value<double> easeFactor;
  final Value<int> interval;
  final Value<int> repetitions;
  final Value<DateTime?> nextReview;
  final Value<int> masteryLevel;
  final Value<bool> bookmarked;
  final Value<int> rowid;
  const QStatesCompanion({
    this.questionId = const Value.absent(),
    this.certId = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.interval = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.nextReview = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.bookmarked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QStatesCompanion.insert({
    required int questionId,
    required String certId,
    this.easeFactor = const Value.absent(),
    this.interval = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.nextReview = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.bookmarked = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : questionId = Value(questionId),
        certId = Value(certId);
  static Insertable<QState> custom({
    Expression<int>? questionId,
    Expression<String>? certId,
    Expression<double>? easeFactor,
    Expression<int>? interval,
    Expression<int>? repetitions,
    Expression<DateTime>? nextReview,
    Expression<int>? masteryLevel,
    Expression<bool>? bookmarked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (certId != null) 'cert_id': certId,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (interval != null) 'interval': interval,
      if (repetitions != null) 'repetitions': repetitions,
      if (nextReview != null) 'next_review': nextReview,
      if (masteryLevel != null) 'mastery_level': masteryLevel,
      if (bookmarked != null) 'bookmarked': bookmarked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QStatesCompanion copyWith(
      {Value<int>? questionId,
      Value<String>? certId,
      Value<double>? easeFactor,
      Value<int>? interval,
      Value<int>? repetitions,
      Value<DateTime?>? nextReview,
      Value<int>? masteryLevel,
      Value<bool>? bookmarked,
      Value<int>? rowid}) {
    return QStatesCompanion(
      questionId: questionId ?? this.questionId,
      certId: certId ?? this.certId,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      nextReview: nextReview ?? this.nextReview,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      bookmarked: bookmarked ?? this.bookmarked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (certId.present) {
      map['cert_id'] = Variable<String>(certId.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (nextReview.present) {
      map['next_review'] = Variable<DateTime>(nextReview.value);
    }
    if (masteryLevel.present) {
      map['mastery_level'] = Variable<int>(masteryLevel.value);
    }
    if (bookmarked.present) {
      map['bookmarked'] = Variable<bool>(bookmarked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QStatesCompanion(')
          ..write('questionId: $questionId, ')
          ..write('certId: $certId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('interval: $interval, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReview: $nextReview, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('bookmarked: $bookmarked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttemptsTable extends Attempts with TableInfo<$AttemptsTable, Attempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
      'question_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _certIdMeta = const VerificationMeta('certId');
  @override
  late final GeneratedColumn<String> certId = GeneratedColumn<String>(
      'cert_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
      'grade', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _attemptedAtMeta =
      const VerificationMeta('attemptedAt');
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
      'attempted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, questionId, certId, grade, attemptedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempts';
  @override
  VerificationContext validateIntegrity(Insertable<Attempt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('cert_id')) {
      context.handle(_certIdMeta,
          certId.isAcceptableOrUnknown(data['cert_id']!, _certIdMeta));
    } else if (isInserting) {
      context.missing(_certIdMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
          _attemptedAtMeta,
          attemptedAt.isAcceptableOrUnknown(
              data['attempted_at']!, _attemptedAtMeta));
    } else if (isInserting) {
      context.missing(_attemptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attempt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}question_id'])!,
      certId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cert_id'])!,
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grade'])!,
      attemptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}attempted_at'])!,
    );
  }

  @override
  $AttemptsTable createAlias(String alias) {
    return $AttemptsTable(attachedDatabase, alias);
  }
}

class Attempt extends DataClass implements Insertable<Attempt> {
  final int id;
  final int questionId;
  final String certId;
  final int grade;
  final DateTime attemptedAt;
  const Attempt(
      {required this.id,
      required this.questionId,
      required this.certId,
      required this.grade,
      required this.attemptedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['question_id'] = Variable<int>(questionId);
    map['cert_id'] = Variable<String>(certId);
    map['grade'] = Variable<int>(grade);
    map['attempted_at'] = Variable<DateTime>(attemptedAt);
    return map;
  }

  AttemptsCompanion toCompanion(bool nullToAbsent) {
    return AttemptsCompanion(
      id: Value(id),
      questionId: Value(questionId),
      certId: Value(certId),
      grade: Value(grade),
      attemptedAt: Value(attemptedAt),
    );
  }

  factory Attempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attempt(
      id: serializer.fromJson<int>(json['id']),
      questionId: serializer.fromJson<int>(json['questionId']),
      certId: serializer.fromJson<String>(json['certId']),
      grade: serializer.fromJson<int>(json['grade']),
      attemptedAt: serializer.fromJson<DateTime>(json['attemptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questionId': serializer.toJson<int>(questionId),
      'certId': serializer.toJson<String>(certId),
      'grade': serializer.toJson<int>(grade),
      'attemptedAt': serializer.toJson<DateTime>(attemptedAt),
    };
  }

  Attempt copyWith(
          {int? id,
          int? questionId,
          String? certId,
          int? grade,
          DateTime? attemptedAt}) =>
      Attempt(
        id: id ?? this.id,
        questionId: questionId ?? this.questionId,
        certId: certId ?? this.certId,
        grade: grade ?? this.grade,
        attemptedAt: attemptedAt ?? this.attemptedAt,
      );
  Attempt copyWithCompanion(AttemptsCompanion data) {
    return Attempt(
      id: data.id.present ? data.id.value : this.id,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      certId: data.certId.present ? data.certId.value : this.certId,
      grade: data.grade.present ? data.grade.value : this.grade,
      attemptedAt:
          data.attemptedAt.present ? data.attemptedAt.value : this.attemptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attempt(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('certId: $certId, ')
          ..write('grade: $grade, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, questionId, certId, grade, attemptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attempt &&
          other.id == this.id &&
          other.questionId == this.questionId &&
          other.certId == this.certId &&
          other.grade == this.grade &&
          other.attemptedAt == this.attemptedAt);
}

class AttemptsCompanion extends UpdateCompanion<Attempt> {
  final Value<int> id;
  final Value<int> questionId;
  final Value<String> certId;
  final Value<int> grade;
  final Value<DateTime> attemptedAt;
  const AttemptsCompanion({
    this.id = const Value.absent(),
    this.questionId = const Value.absent(),
    this.certId = const Value.absent(),
    this.grade = const Value.absent(),
    this.attemptedAt = const Value.absent(),
  });
  AttemptsCompanion.insert({
    this.id = const Value.absent(),
    required int questionId,
    required String certId,
    required int grade,
    required DateTime attemptedAt,
  })  : questionId = Value(questionId),
        certId = Value(certId),
        grade = Value(grade),
        attemptedAt = Value(attemptedAt);
  static Insertable<Attempt> custom({
    Expression<int>? id,
    Expression<int>? questionId,
    Expression<String>? certId,
    Expression<int>? grade,
    Expression<DateTime>? attemptedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (certId != null) 'cert_id': certId,
      if (grade != null) 'grade': grade,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
    });
  }

  AttemptsCompanion copyWith(
      {Value<int>? id,
      Value<int>? questionId,
      Value<String>? certId,
      Value<int>? grade,
      Value<DateTime>? attemptedAt}) {
    return AttemptsCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      certId: certId ?? this.certId,
      grade: grade ?? this.grade,
      attemptedAt: attemptedAt ?? this.attemptedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (certId.present) {
      map['cert_id'] = Variable<String>(certId.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsCompanion(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('certId: $certId, ')
          ..write('grade: $grade, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyActivitiesTable extends DailyActivities
    with TableInfo<$DailyActivitiesTable, DailyActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _certIdMeta = const VerificationMeta('certId');
  @override
  late final GeneratedColumn<String> certId = GeneratedColumn<String>(
      'cert_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _correctCountMeta =
      const VerificationMeta('correctCount');
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
      'correct_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [date, certId, count, correctCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activities';
  @override
  VerificationContext validateIntegrity(Insertable<DailyActivity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('cert_id')) {
      context.handle(_certIdMeta,
          certId.isAcceptableOrUnknown(data['cert_id']!, _certIdMeta));
    } else if (isInserting) {
      context.missing(_certIdMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    }
    if (data.containsKey('correct_count')) {
      context.handle(
          _correctCountMeta,
          correctCount.isAcceptableOrUnknown(
              data['correct_count']!, _correctCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, certId};
  @override
  DailyActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivity(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      certId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cert_id'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      correctCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_count'])!,
    );
  }

  @override
  $DailyActivitiesTable createAlias(String alias) {
    return $DailyActivitiesTable(attachedDatabase, alias);
  }
}

class DailyActivity extends DataClass implements Insertable<DailyActivity> {
  final String date;
  final String certId;
  final int count;
  final int correctCount;
  const DailyActivity(
      {required this.date,
      required this.certId,
      required this.count,
      required this.correctCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['cert_id'] = Variable<String>(certId);
    map['count'] = Variable<int>(count);
    map['correct_count'] = Variable<int>(correctCount);
    return map;
  }

  DailyActivitiesCompanion toCompanion(bool nullToAbsent) {
    return DailyActivitiesCompanion(
      date: Value(date),
      certId: Value(certId),
      count: Value(count),
      correctCount: Value(correctCount),
    );
  }

  factory DailyActivity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivity(
      date: serializer.fromJson<String>(json['date']),
      certId: serializer.fromJson<String>(json['certId']),
      count: serializer.fromJson<int>(json['count']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'certId': serializer.toJson<String>(certId),
      'count': serializer.toJson<int>(count),
      'correctCount': serializer.toJson<int>(correctCount),
    };
  }

  DailyActivity copyWith(
          {String? date, String? certId, int? count, int? correctCount}) =>
      DailyActivity(
        date: date ?? this.date,
        certId: certId ?? this.certId,
        count: count ?? this.count,
        correctCount: correctCount ?? this.correctCount,
      );
  DailyActivity copyWithCompanion(DailyActivitiesCompanion data) {
    return DailyActivity(
      date: data.date.present ? data.date.value : this.date,
      certId: data.certId.present ? data.certId.value : this.certId,
      count: data.count.present ? data.count.value : this.count,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivity(')
          ..write('date: $date, ')
          ..write('certId: $certId, ')
          ..write('count: $count, ')
          ..write('correctCount: $correctCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, certId, count, correctCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivity &&
          other.date == this.date &&
          other.certId == this.certId &&
          other.count == this.count &&
          other.correctCount == this.correctCount);
}

class DailyActivitiesCompanion extends UpdateCompanion<DailyActivity> {
  final Value<String> date;
  final Value<String> certId;
  final Value<int> count;
  final Value<int> correctCount;
  final Value<int> rowid;
  const DailyActivitiesCompanion({
    this.date = const Value.absent(),
    this.certId = const Value.absent(),
    this.count = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActivitiesCompanion.insert({
    required String date,
    required String certId,
    this.count = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : date = Value(date),
        certId = Value(certId);
  static Insertable<DailyActivity> custom({
    Expression<String>? date,
    Expression<String>? certId,
    Expression<int>? count,
    Expression<int>? correctCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (certId != null) 'cert_id': certId,
      if (count != null) 'count': count,
      if (correctCount != null) 'correct_count': correctCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActivitiesCompanion copyWith(
      {Value<String>? date,
      Value<String>? certId,
      Value<int>? count,
      Value<int>? correctCount,
      Value<int>? rowid}) {
    return DailyActivitiesCompanion(
      date: date ?? this.date,
      certId: certId ?? this.certId,
      count: count ?? this.count,
      correctCount: correctCount ?? this.correctCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (certId.present) {
      map['cert_id'] = Variable<String>(certId.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivitiesCompanion(')
          ..write('date: $date, ')
          ..write('certId: $certId, ')
          ..write('count: $count, ')
          ..write('correctCount: $correctCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) => Setting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CertsTable certs = $CertsTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $QStatesTable qStates = $QStatesTable(this);
  late final $AttemptsTable attempts = $AttemptsTable(this);
  late final $DailyActivitiesTable dailyActivities =
      $DailyActivitiesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final CertDao certDao = CertDao(this as AppDatabase);
  late final QuestionDao questionDao = QuestionDao(this as AppDatabase);
  late final QStateDao qStateDao = QStateDao(this as AppDatabase);
  late final AttemptDao attemptDao = AttemptDao(this as AppDatabase);
  late final DailyActivityDao dailyActivityDao =
      DailyActivityDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [certs, questions, qStates, attempts, dailyActivities, settings];
}

typedef $$CertsTableCreateCompanionBuilder = CertsCompanion Function({
  required String certId,
  required String certName,
  required String category,
  required int totalItems,
  Value<String> version,
  Value<int> rowid,
});
typedef $$CertsTableUpdateCompanionBuilder = CertsCompanion Function({
  Value<String> certId,
  Value<String> certName,
  Value<String> category,
  Value<int> totalItems,
  Value<String> version,
  Value<int> rowid,
});

class $$CertsTableFilterComposer extends Composer<_$AppDatabase, $CertsTable> {
  $$CertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get certName => $composableBuilder(
      column: $table.certName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalItems => $composableBuilder(
      column: $table.totalItems, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$CertsTableOrderingComposer
    extends Composer<_$AppDatabase, $CertsTable> {
  $$CertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get certName => $composableBuilder(
      column: $table.certName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalItems => $composableBuilder(
      column: $table.totalItems, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$CertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CertsTable> {
  $$CertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get certId =>
      $composableBuilder(column: $table.certId, builder: (column) => column);

  GeneratedColumn<String> get certName =>
      $composableBuilder(column: $table.certName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get totalItems => $composableBuilder(
      column: $table.totalItems, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$CertsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CertsTable,
    Cert,
    $$CertsTableFilterComposer,
    $$CertsTableOrderingComposer,
    $$CertsTableAnnotationComposer,
    $$CertsTableCreateCompanionBuilder,
    $$CertsTableUpdateCompanionBuilder,
    (Cert, BaseReferences<_$AppDatabase, $CertsTable, Cert>),
    Cert,
    PrefetchHooks Function()> {
  $$CertsTableTableManager(_$AppDatabase db, $CertsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> certId = const Value.absent(),
            Value<String> certName = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> totalItems = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CertsCompanion(
            certId: certId,
            certName: certName,
            category: category,
            totalItems: totalItems,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String certId,
            required String certName,
            required String category,
            required int totalItems,
            Value<String> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CertsCompanion.insert(
            certId: certId,
            certName: certName,
            category: category,
            totalItems: totalItems,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CertsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CertsTable,
    Cert,
    $$CertsTableFilterComposer,
    $$CertsTableOrderingComposer,
    $$CertsTableAnnotationComposer,
    $$CertsTableCreateCompanionBuilder,
    $$CertsTableUpdateCompanionBuilder,
    (Cert, BaseReferences<_$AppDatabase, $CertsTable, Cert>),
    Cert,
    PrefetchHooks Function()>;
typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  required int id,
  required String certId,
  required String question,
  required String answer,
  required String aiExplanation,
  Value<String> tags,
  Value<int> difficulty,
  Value<int> rowid,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<int> id,
  Value<String> certId,
  Value<String> question,
  Value<String> answer,
  Value<String> aiExplanation,
  Value<String> tags,
  Value<int> difficulty,
  Value<int> rowid,
});

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aiExplanation => $composableBuilder(
      column: $table.aiExplanation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aiExplanation => $composableBuilder(
      column: $table.aiExplanation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get certId =>
      $composableBuilder(column: $table.certId, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get aiExplanation => $composableBuilder(
      column: $table.aiExplanation, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);
}

class $$QuestionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionsTable,
    Question,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
    Question,
    PrefetchHooks Function()> {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> certId = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<String> aiExplanation = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int> difficulty = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsCompanion(
            id: id,
            certId: certId,
            question: question,
            answer: answer,
            aiExplanation: aiExplanation,
            tags: tags,
            difficulty: difficulty,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String certId,
            required String question,
            required String answer,
            required String aiExplanation,
            Value<String> tags = const Value.absent(),
            Value<int> difficulty = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsCompanion.insert(
            id: id,
            certId: certId,
            question: question,
            answer: answer,
            aiExplanation: aiExplanation,
            tags: tags,
            difficulty: difficulty,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuestionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuestionsTable,
    Question,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableAnnotationComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder,
    (Question, BaseReferences<_$AppDatabase, $QuestionsTable, Question>),
    Question,
    PrefetchHooks Function()>;
typedef $$QStatesTableCreateCompanionBuilder = QStatesCompanion Function({
  required int questionId,
  required String certId,
  Value<double> easeFactor,
  Value<int> interval,
  Value<int> repetitions,
  Value<DateTime?> nextReview,
  Value<int> masteryLevel,
  Value<bool> bookmarked,
  Value<int> rowid,
});
typedef $$QStatesTableUpdateCompanionBuilder = QStatesCompanion Function({
  Value<int> questionId,
  Value<String> certId,
  Value<double> easeFactor,
  Value<int> interval,
  Value<int> repetitions,
  Value<DateTime?> nextReview,
  Value<int> masteryLevel,
  Value<bool> bookmarked,
  Value<int> rowid,
});

class $$QStatesTableFilterComposer
    extends Composer<_$AppDatabase, $QStatesTable> {
  $$QStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get bookmarked => $composableBuilder(
      column: $table.bookmarked, builder: (column) => ColumnFilters(column));
}

class $$QStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $QStatesTable> {
  $$QStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get bookmarked => $composableBuilder(
      column: $table.bookmarked, builder: (column) => ColumnOrderings(column));
}

class $$QStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QStatesTable> {
  $$QStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<String> get certId =>
      $composableBuilder(column: $table.certId, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReview => $composableBuilder(
      column: $table.nextReview, builder: (column) => column);

  GeneratedColumn<int> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel, builder: (column) => column);

  GeneratedColumn<bool> get bookmarked => $composableBuilder(
      column: $table.bookmarked, builder: (column) => column);
}

class $$QStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QStatesTable,
    QState,
    $$QStatesTableFilterComposer,
    $$QStatesTableOrderingComposer,
    $$QStatesTableAnnotationComposer,
    $$QStatesTableCreateCompanionBuilder,
    $$QStatesTableUpdateCompanionBuilder,
    (QState, BaseReferences<_$AppDatabase, $QStatesTable, QState>),
    QState,
    PrefetchHooks Function()> {
  $$QStatesTableTableManager(_$AppDatabase db, $QStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> questionId = const Value.absent(),
            Value<String> certId = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> interval = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<DateTime?> nextReview = const Value.absent(),
            Value<int> masteryLevel = const Value.absent(),
            Value<bool> bookmarked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QStatesCompanion(
            questionId: questionId,
            certId: certId,
            easeFactor: easeFactor,
            interval: interval,
            repetitions: repetitions,
            nextReview: nextReview,
            masteryLevel: masteryLevel,
            bookmarked: bookmarked,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int questionId,
            required String certId,
            Value<double> easeFactor = const Value.absent(),
            Value<int> interval = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<DateTime?> nextReview = const Value.absent(),
            Value<int> masteryLevel = const Value.absent(),
            Value<bool> bookmarked = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QStatesCompanion.insert(
            questionId: questionId,
            certId: certId,
            easeFactor: easeFactor,
            interval: interval,
            repetitions: repetitions,
            nextReview: nextReview,
            masteryLevel: masteryLevel,
            bookmarked: bookmarked,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QStatesTable,
    QState,
    $$QStatesTableFilterComposer,
    $$QStatesTableOrderingComposer,
    $$QStatesTableAnnotationComposer,
    $$QStatesTableCreateCompanionBuilder,
    $$QStatesTableUpdateCompanionBuilder,
    (QState, BaseReferences<_$AppDatabase, $QStatesTable, QState>),
    QState,
    PrefetchHooks Function()>;
typedef $$AttemptsTableCreateCompanionBuilder = AttemptsCompanion Function({
  Value<int> id,
  required int questionId,
  required String certId,
  required int grade,
  required DateTime attemptedAt,
});
typedef $$AttemptsTableUpdateCompanionBuilder = AttemptsCompanion Function({
  Value<int> id,
  Value<int> questionId,
  Value<String> certId,
  Value<int> grade,
  Value<DateTime> attemptedAt,
});

class $$AttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => ColumnFilters(column));
}

class $$AttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => ColumnOrderings(column));
}

class $$AttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptsTable> {
  $$AttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get questionId => $composableBuilder(
      column: $table.questionId, builder: (column) => column);

  GeneratedColumn<String> get certId =>
      $composableBuilder(column: $table.certId, builder: (column) => column);

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => column);
}

class $$AttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttemptsTable,
    Attempt,
    $$AttemptsTableFilterComposer,
    $$AttemptsTableOrderingComposer,
    $$AttemptsTableAnnotationComposer,
    $$AttemptsTableCreateCompanionBuilder,
    $$AttemptsTableUpdateCompanionBuilder,
    (Attempt, BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>),
    Attempt,
    PrefetchHooks Function()> {
  $$AttemptsTableTableManager(_$AppDatabase db, $AttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> questionId = const Value.absent(),
            Value<String> certId = const Value.absent(),
            Value<int> grade = const Value.absent(),
            Value<DateTime> attemptedAt = const Value.absent(),
          }) =>
              AttemptsCompanion(
            id: id,
            questionId: questionId,
            certId: certId,
            grade: grade,
            attemptedAt: attemptedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int questionId,
            required String certId,
            required int grade,
            required DateTime attemptedAt,
          }) =>
              AttemptsCompanion.insert(
            id: id,
            questionId: questionId,
            certId: certId,
            grade: grade,
            attemptedAt: attemptedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttemptsTable,
    Attempt,
    $$AttemptsTableFilterComposer,
    $$AttemptsTableOrderingComposer,
    $$AttemptsTableAnnotationComposer,
    $$AttemptsTableCreateCompanionBuilder,
    $$AttemptsTableUpdateCompanionBuilder,
    (Attempt, BaseReferences<_$AppDatabase, $AttemptsTable, Attempt>),
    Attempt,
    PrefetchHooks Function()>;
typedef $$DailyActivitiesTableCreateCompanionBuilder = DailyActivitiesCompanion
    Function({
  required String date,
  required String certId,
  Value<int> count,
  Value<int> correctCount,
  Value<int> rowid,
});
typedef $$DailyActivitiesTableUpdateCompanionBuilder = DailyActivitiesCompanion
    Function({
  Value<String> date,
  Value<String> certId,
  Value<int> count,
  Value<int> correctCount,
  Value<int> rowid,
});

class $$DailyActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyActivitiesTable> {
  $$DailyActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => ColumnFilters(column));
}

class $$DailyActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyActivitiesTable> {
  $$DailyActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get certId => $composableBuilder(
      column: $table.certId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctCount => $composableBuilder(
      column: $table.correctCount,
      builder: (column) => ColumnOrderings(column));
}

class $$DailyActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyActivitiesTable> {
  $$DailyActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get certId =>
      $composableBuilder(column: $table.certId, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
      column: $table.correctCount, builder: (column) => column);
}

class $$DailyActivitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyActivitiesTable,
    DailyActivity,
    $$DailyActivitiesTableFilterComposer,
    $$DailyActivitiesTableOrderingComposer,
    $$DailyActivitiesTableAnnotationComposer,
    $$DailyActivitiesTableCreateCompanionBuilder,
    $$DailyActivitiesTableUpdateCompanionBuilder,
    (
      DailyActivity,
      BaseReferences<_$AppDatabase, $DailyActivitiesTable, DailyActivity>
    ),
    DailyActivity,
    PrefetchHooks Function()> {
  $$DailyActivitiesTableTableManager(
      _$AppDatabase db, $DailyActivitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<String> certId = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyActivitiesCompanion(
            date: date,
            certId: certId,
            count: count,
            correctCount: correctCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String date,
            required String certId,
            Value<int> count = const Value.absent(),
            Value<int> correctCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyActivitiesCompanion.insert(
            date: date,
            certId: certId,
            count: count,
            correctCount: correctCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyActivitiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyActivitiesTable,
    DailyActivity,
    $$DailyActivitiesTableFilterComposer,
    $$DailyActivitiesTableOrderingComposer,
    $$DailyActivitiesTableAnnotationComposer,
    $$DailyActivitiesTableCreateCompanionBuilder,
    $$DailyActivitiesTableUpdateCompanionBuilder,
    (
      DailyActivity,
      BaseReferences<_$AppDatabase, $DailyActivitiesTable, DailyActivity>
    ),
    DailyActivity,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CertsTableTableManager get certs =>
      $$CertsTableTableManager(_db, _db.certs);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$QStatesTableTableManager get qStates =>
      $$QStatesTableTableManager(_db, _db.qStates);
  $$AttemptsTableTableManager get attempts =>
      $$AttemptsTableTableManager(_db, _db.attempts);
  $$DailyActivitiesTableTableManager get dailyActivities =>
      $$DailyActivitiesTableTableManager(_db, _db.dailyActivities);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
