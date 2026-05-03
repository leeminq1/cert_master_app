import 'package:drift/drift.dart';

class Certs extends Table {
  TextColumn get certId    => text()();
  TextColumn get certName  => text()();
  TextColumn get category  => text()();
  IntColumn  get totalItems => integer()();
  TextColumn get version   => text().withDefault(const Constant('1.0'))();

  @override
  Set<Column> get primaryKey => {certId};
}

class Questions extends Table {
  IntColumn  get id             => integer()();
  TextColumn get certId         => text()();
  TextColumn get question       => text()();
  TextColumn get answer         => text()();
  TextColumn get aiExplanation  => text()();  // JSON string
  TextColumn get tags           => text().withDefault(const Constant('[]'))();
  IntColumn  get difficulty     => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id, certId};
}

class QStates extends Table {
  IntColumn      get questionId   => integer()();
  TextColumn     get certId       => text()();
  RealColumn     get easeFactor   => real().withDefault(const Constant(2.5))();
  IntColumn      get interval     => integer().withDefault(const Constant(1))();
  IntColumn      get repetitions  => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextReview   => dateTime().nullable()();
  IntColumn      get masteryLevel => integer().withDefault(const Constant(0))();
  BoolColumn     get bookmarked   => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {questionId, certId};
}

// P1에서 활성화
class Attempts extends Table {
  IntColumn      get id          => integer().autoIncrement()();
  IntColumn      get questionId  => integer()();
  TextColumn     get certId      => text()();
  IntColumn      get grade       => integer()();  // 0=다시 1=애매 2=확실
  DateTimeColumn get attemptedAt => dateTime()();
}

class DailyActivities extends Table {
  TextColumn get date         => text()();  // 'YYYY-MM-DD'
  TextColumn get certId       => text()();
  IntColumn  get count        => integer().withDefault(const Constant(0))();
  IntColumn  get correctCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date, certId};
}

class Settings extends Table {
  TextColumn get key   => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
