class SM2Result {
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime nextReview;
  final int masteryLevel;

  const SM2Result({
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReview,
    required this.masteryLevel,
  });
}

/// Computes the next SM-2 state given the current state and user grade.
/// grade: 0=다시(fail), 1=애매(hard), 2=확실(easy)
SM2Result computeSM2({
  required double easeFactor,
  required int interval,
  required int repetitions,
  required int masteryLevel,
  required int grade,
}) {
  final int newInterval;
  final int newRepetitions;

  if (grade < 1) {
    newRepetitions = 0;
    newInterval = 1;
  } else {
    if (repetitions == 0) {
      newInterval = 1;
    } else if (repetitions == 1) {
      newInterval = 3;
    } else {
      newInterval = (interval * easeFactor).round();
    }
    newRepetitions = repetitions + 1;
  }

  final newEase =
      (easeFactor + 0.1 - (2 - grade) * (0.08 + (2 - grade) * 0.02))
          .clamp(1.3, 5.0);
  final newMastery = (masteryLevel + (grade >= 2 ? 1 : -1)).clamp(0, 5);

  return SM2Result(
    easeFactor: newEase,
    interval: newInterval,
    repetitions: newRepetitions,
    nextReview: DateTime.now().add(Duration(days: newInterval)),
    masteryLevel: newMastery,
  );
}
