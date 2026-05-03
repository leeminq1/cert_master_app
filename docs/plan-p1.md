# P1 구현 가이드 — 기억 루프 (Memory Loop)

> **상태**: ✅ 완료
>
> **목표**: SM-2 복습 스케줄링, 오답노트, 북마크, 스트릭, 로컬 알림, 테마 설정
>
> **완료 기준**: 자가평가 → SM-2 nextReview 저장, 오답/북마크 목록 확인, 스트릭 뱃지, 알림 수신, 테마 전환 저장

---

## ⚠️ design_handoff 대비 실제 앱 변경 사항

> 디자인 원안과 충돌하면 **현재 코드(아래 표)가 최종 결정**이다.

| 항목 | 원래 design_handoff | 실제 구현 |
|------|-------------------|------------|
| Screen 02 모드 카드 이름 | "전체 기출" | **"전체학습"** |
| Screen 03/04 구조 | QuizScreen(문제) → ExplanationScreen(정답/해설) 2페이지 | **QuizScreen 1페이지 내 인라인 표시** |
| 자가평가 버튼 | 3개 (다시 grade=0 / 애매 grade=1 / 확실 grade=2) | **2개 (다시볼게요 grade=0 / 이해했어요 grade=2)** |
| Screen 05 탭 수 | 3탭 (오답 · 북마크 · 모름) | **2탭 (다시보는 개념 · 북마크)** |
| Screen 05 "오답" 탭 이름 | 오답 | **다시보는 개념** |
| Screen 05 "모름" 탭 | 있음 (masteryLevel < 2) | **제거** |
| Screen 05 상세 뷰 | 별도 뷰 | **ExplanationScreen 동일 UI, 자가평가 버튼만 숨김** |
| 전체학습 시작점 | 항상 1번부터 | **마지막 학습 위치에서 이어서 시작** |
| Screen 04 ExplanationScreen 역할 | 주 학습 흐름 정답 확인 | **WrongNote 상세 보기 전용** |

---

## P1 추가 패키지

```yaml
# P0 pubspec에서 이미 포함됨 (별도 추가 불필요)
flutter_local_notifications: ^17.0.0
timezone: ^0.9.0
```

---

## P1 추가/수정 파일 (완료)

```
lib/
├── core/utils/
│   └── sm2.dart                          ✅ SM-2 알고리즘
├── data/database/
│   ├── tables.dart                       ✅ Attempts, DailyActivities, Settings 테이블 추가
│   └── daos/
│       ├── attempt_dao.dart              ✅
│       ├── daily_activity_dao.dart       ✅
│       └── settings_dao.dart             ✅
├── providers/
│   ├── study_providers.dart              ✅ streakProvider, certQStatesProvider
│   ├── quiz_providers.dart               ✅ currentQStateProvider, SM-2 적용
│   └── settings_providers.dart          ✅ themeModeProvider, notificationEnabledProvider
├── features/
│   ├── home/home_screen.dart            ✅ 스트릭 뱃지 추가
│   ├── quiz/quiz_screen.dart            ✅ 진도 재개 (DB 저장), _navigateToIndex()
│   ├── quiz/explanation_screen.dart     ✅ showGradeButtons 파라미터, 문제 카드 조건부
│   ├── wrong_note/wrong_note_screen.dart ✅ 2탭, ExplanationScreen 네비게이션, ✕ 삭제
│   └── settings/settings_screen.dart    ✅ 테마/알림 토글, 일일 알림 시간 피커
├── services/
│   └── notification_service.dart        ✅ 3종 알림 구현
└── app.dart                              ✅ themeModeProvider 연결
```

---

## SM-2 알고리즘 (core/utils/sm2.dart)

> **UI에서 실제 사용하는 grade 값: 0 (다시볼게요), 2 (이해했어요)**
> SM-2 함수는 grade=1도 받을 수 있으나 현재 UI에 grade=1 버튼 없음.

```dart
/// grade: 0=다시(틀림), 1=애매(미사용), 2=확실(맞음)
SM2Result computeSM2({
  required double easeFactor,
  required int interval,
  required int repetitions,
  required int masteryLevel,
  required int grade,
})
```

### 계산 규칙 (현재 구현값)

| 상황 | interval | repetitions | masteryLevel |
|---|---|---|---|
| grade=0 (다시) | → 1 | → 0 | `(masteryLevel - 1).clamp(0, 5)` |
| grade=2, rep=0 | → 1 | → 1 | `(masteryLevel + 1).clamp(0, 5)` |
| grade=2, rep=1 | → 3 | → 2 | `(masteryLevel + 1).clamp(0, 5)` |
| grade=2, rep≥2 | → `(interval × easeFactor).round()` | rep+1 | `(masteryLevel + 1).clamp(0, 5)` |

- **easeFactor**: `(ef + 0.1 - (2-grade) * (0.08 + (2-grade) * 0.02)).clamp(1.3, 5.0)`
- **nextReview**: `DateTime.now().add(Duration(days: newInterval))`
- **다시보는 개념 탭 쿼리**: `QState 존재 && masteryLevel == 0`

---

## P1 추가 테이블 (tables.dart)

```dart
class Attempts extends Table {
  IntColumn      get id          => integer().autoIncrement()();
  IntColumn      get questionId  => integer()();
  TextColumn     get certId      => text()();
  IntColumn      get grade       => integer()();  // 0=다시 2=확실
  DateTimeColumn get attemptedAt => dateTime()();
}

class DailyActivities extends Table {
  TextColumn get date         => text()();   // 'YYYY-MM-DD'
  TextColumn get certId       => text()();
  IntColumn  get count        => integer().withDefault(const Constant(0))();
  IntColumn  get correctCount => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {date, certId};
}

class Settings extends Table {
  TextColumn get key   => text()();
  TextColumn get value => text()();
  @override Set<Column> get primaryKey => {key};
}
```

---

## Settings 테이블 키 목록 (실제 사용)

| 키 | 값 형식 | 사용처 |
|---|---|---|
| `theme_mode` | `'light'`\|`'dark'`\|`'system'` | ThemeModeNotifier |
| `notification_enabled` | `'true'`\|`'false'` | NotificationEnabledNotifier |
| `notification_requested` | `'1'` | ExplanationScreen, 최초 1회 권한 요청 후 |
| `quiz_last_index_{certId}` | `'42'` (정수 문자열) | QuizScreen 진도 재개 |
| `daily_hour` | `'9'` (정수 문자열) | SettingsScreen 일일 알림 시간 |
| `daily_minute` | `'0'` (정수 문자열) | SettingsScreen 일일 알림 시간 |
| `daily_enabled` | `'true'`\|`'false'` | SettingsScreen 일일 알림 토글 |

---

## Screen 05 — 오답·북마크 (WrongNoteScreen) ✅

**라우트**: `/cert/:certId/wrong-note`

```
AppBar: "오답·북마크"  ← 뒤로가기

TabBar (2탭)
  [다시보는 개념] [북마크]
  labelColor: lime / indicatorColor: lime

Body: ListView
  각 카드:
    난이도 Chip (기본/보통/심화)
    ✕ 버튼 (삭제) — 다시보는 개념: masteryLevel→1, 북마크: bookmarked→false
    question 텍스트 (3줄까지, overflow ellipsis)
    ▸ 탭 시 ExplanationScreen (showGradeButtons=false)

Empty state: 각 탭별 안내 문구
```

**탭별 데이터 쿼리**:

```dart
// 다시보는 개념: QState 존재 && masteryLevel == 0
final retry = questions.where((q) {
  final s = stateMap[q.id];
  return s != null && s.masteryLevel == 0;
}).toList();

// 북마크
final bookmarked = questions.where((q) {
  return stateMap[q.id]?.bookmarked == true;
}).toList();
```

**카드 탭 시 네비게이션**:
```dart
context.push(
  '/cert/$certId/explanation?questionId=${q.id}',
  extra: false,  // showGradeButtons=false 전달
);
```

---

## 전체학습 진도 재개 (Quiz Resume)

**구현**: Settings 테이블에 `quiz_last_index_{certId}` 키로 마지막 인덱스 저장.

```dart
// quiz_screen.dart — initState에서 저장된 인덱스 로드
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (!mounted) return;
    final saved = await ref.read(databaseProvider).settingsDao
        .getLastQuizIndex(widget.certId);
    if (saved > 0 && mounted) {
      ref.read(currentQuestionIndexProvider(widget.certId).notifier).state = saved;
    }
  });
}

// 인덱스 변경 시 항상 DB에 저장
void _navigateToIndex(int newIndex) {
  ref.read(currentQuestionIndexProvider(widget.certId).notifier).state = newIndex;
  ref.read(databaseProvider).settingsDao.setLastQuizIndex(widget.certId, newIndex);
}

// 퀴즈 완료 시 인덱스 0으로 리셋
await ref.read(databaseProvider).settingsDao.setLastQuizIndex(widget.certId, 0);
```

---

## 스트릭 (Streak) 계산

```dart
// study_providers.dart
// 오늘 포함 연속으로 daily_activity에 기록이 있는 날 수
// 오늘 활동이 없어도 어제까지 연속이면 streak 유지 (당일 미학습 허용)

final streakProvider = FutureProvider<int>((ref) async {
  final dates = await db.dailyActivityDao.getActiveDates();
  int streak = 0;
  for (int i = 0; i < 365; i++) {
    final day = DateTime(now.year, now.month, now.day - i);
    if (dateSet.contains(formatted(day))) {
      streak++;
    } else if (i == 0) {
      continue;  // 오늘 아직 안 했으면 어제부터 확인
    } else {
      break;
    }
  }
  return streak;
});
```

---

## 로컬 알림 (NotificationService)

**패키지**: `flutter_local_notifications ^17.0.0` + `timezone ^0.9.0`

### 3종 알림 구현 현황

| ID | 종류 | 트리거 | 내용 |
|---|---|---|---|
| 42 | 3일 미접속 알림 | 자가평가 완료 시마다 재설정 (3일 후) | "오늘도 자격증 공부해볼까요? 📚" |
| 44 | SM-2 복습 알림 | 자가평가 완료 시 `sm2.nextReview` 날짜에 | "복습할 시간이에요! 📖" |
| 43 | 일일 목표 알림 | 설정에서 활성화 시, 매일 반복 | "오늘의 자격증 공부 시간이에요! 🎯" |

### 권한 요청 시점
- ExplanationScreen에서 **최초 자가평가 완료 후 1회만** 요청
- `settings['notification_requested']` 키로 중복 요청 방지

### 알림 초기화 위치
```dart
// main.dart
await NotificationService.init();  // timezone 초기화 포함
```

---

## 테마 저장 (ThemeModeNotifier)

```dart
// providers/settings_providers.dart
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(databaseProvider));
});

// app.dart
final themeMode = ref.watch(themeModeProvider);
MaterialApp.router(themeMode: themeMode, ...)
```

- DB 키: `theme_mode` → `'light'` | `'dark'` | `'system'`
- 앱 시작 시 비동기 로드 → 로드 전까지 `ThemeMode.system` 유지

---

## SettingsScreen 현재 구현 (P1 기본)

**라우트**: `/settings`

```
Section: 테마
  시스템 / 라이트 / 다크 선택 (저장됨)

Section: 알림
  복습 알림 토글 (3일 미접속)
  매일 알림 토글 + 시간 피커 (저장됨)

※ 미구현 (P2로): 백업/복원, 학습 기록 초기화, 일일 목표 슬라이더, 폰트 크기
```

---

## P1 검증 체크리스트

```
[x] 문제 5개 풀고 "다시볼게요" 선택 → WrongNoteScreen "다시보는 개념" 탭에서 확인
[x] 북마크 아이콘 탭 → 북마크 탭에서 확인
[x] WrongNote 카드 ✕ 탭 → 목록에서 제거
[x] WrongNote 카드 탭 → ExplanationScreen (문제+정답 모두 표시, 자가평가 버튼 없음)
[x] QStates 테이블에 SM-2 값 업데이트 확인 (masteryLevel, interval, easeFactor)
[x] 연속 학습 → HomeScreen에서 🔥 N일 뱃지 표시
[x] 앱 재시작 → 전체학습 이전 위치에서 이어서 시작
[x] 첫 자가평가 완료 후 알림 권한 요청 다이얼로그 표시
[x] 설정 화면 테마 토글 → 전체 앱 테마 즉시 반영 + 재시작 후 유지
[x] 설정 화면 매일 알림 ON → 시간 피커 표시 → 저장 후 재시작해도 유지
[x] 다크/라이트 양쪽에서 WrongNoteScreen 색상 정상
```

---

## P1 완료 후 남은 작업 (P2로 이관)

| 항목 | 분류 |
|---|---|
| SettingsScreen 백업/복원 (JSON 내보내기/불러오기) | P2 구현 |
| SettingsScreen 학습 기록 초기화 | P2 구현 |
| SettingsScreen 일일 목표 슬라이더 / 폰트 크기 | P2 구현 |
| SM-2 단위 테스트 (`flutter test`) | 권장 |
| streak 계산 단위 테스트 | 권장 |
| DB migration 전략 (schema_version 올릴 때) | 결정 필요 — 현재 개발 중에는 재설치로 대응 |
| notification key 이름 통일 (`notification_requested` vs. plan-p2의 `notification_prompted`) | 현재 코드는 `notification_requested` 사용 |
