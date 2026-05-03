# P0 구현 가이드 — 퀴즈 루프 (Quiz Loop)

> **상태**: ✅ 완료
>
> **목표**: 앱 실행 → 자격증 선택 → 문제 풀고 정답 확인 → 자가평가 후 다음 문제
>
> **완료 기준**: 홈에서 자격증 선택 → 문제 풀고 정답 확인 → "다시볼게요/이해했어요" 탭 → 다음 문제로 이동, SQLite에 학습 기록 저장

---

## ⚠️ design_handoff 대비 실제 구현 변경 사항

| 항목 | 원래 design_handoff | 실제 구현 (코드 기준) |
|---|---|---|
| Screen 02 모드 카드 이름 | "전체 기출" | **"전체학습"** |
| Screen 03/04 구조 | QuizScreen(문제) → ExplanationScreen(정답) 2페이지 | **QuizScreen 1페이지 내 인라인 표시** |
| Screen 03 자가평가 버튼 | 3개 (다시 / 애매 / 확실) | **2개 (다시볼게요 grade=0 / 이해했어요 grade=2)** |
| Screen 04 ExplanationScreen 역할 | 주 학습 흐름의 정답 확인 화면 | **WrongNote 상세 보기 전용** (`showGradeButtons=false`) |

---

## 참조 디자인 파일

| 파일 | 용도 |
|------|------|
| `자격증 마스터앱_디자인/design_handoff_cert_master/design/main.html` | 스크린 1~4 시각적 확인 (브라우저에서 열 것) |
| `자격증 마스터앱_디자인/design_handoff_cert_master/design/tokens.jsx` | THEMES 객체 (다크/라이트 색상 토큰) + CERTS 배열 |
| `자격증 마스터앱_디자인/design_handoff_cert_master/design/screens-1.jsx` | 화면 1~4 JSX 레이아웃 상세 |
| `자격증 마스터앱_디자인/design_handoff_cert_master/spec/dev-plan.html` | 슬라이드 5(기술스택), 6(JSON스키마), 7~8(SQLite스키마) |
| `자격증 마스터앱_디자인/design_handoff_cert_master/README.md` | Screen 01~04 상세 설명 + Critical Don'ts |
| `assets/data/forklift.json` | 데이터 스키마 예시 |

---

## 기술 스택 (실제 pubspec.yaml 기준)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # 데이터베이스 (SQLite ORM)
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.5.0   # drift_flutter 대신 사용
  path_provider: ^2.1.0
  path: ^1.9.0

  # 상태관리
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # 라우팅
  go_router: ^13.0.0

  # 폰트
  google_fonts: ^6.2.0

  # 알림 (P1에서 사용, pubspec에는 P0부터 포함)
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.0

  # P2 준비 (pubspec에 이미 포함됨)
  fl_chart: ^0.68.0
  share_plus: ^12.0.2
  file_picker: ^8.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.0
  drift_dev: ^2.20.0
  riverpod_generator: ^2.4.0
  riverpod_lint: ^2.3.0

flutter:
  assets:
    - assets/data/
```

---

## 구현 파일 목록 (P0)

```
lib/
├── main.dart                              # ProviderContainer + UncontrolledProviderScope + runApp
├── app.dart                               # MaterialApp.router + themeModeProvider (P1에서 추가)
├── core/
│   ├── theme/
│   │   ├── app_colors.dart               # 색상 상수 (tokens.jsx THEMES 번역)
│   │   └── app_theme.dart                # ThemeData dark/light 생성
│   └── router/
│       └── app_router.dart               # GoRouter (12개 라우트)
├── data/
│   ├── database/
│   │   ├── app_database.dart             # @DriftDatabase 선언 (6테이블, 6 DAO)
│   │   ├── tables.dart                   # 6개 테이블 정의
│   │   └── daos/
│   │       ├── cert_dao.dart
│   │       ├── question_dao.dart
│   │       └── q_state_dao.dart
│   ├── models/
│   │   └── cert_json.dart                # JSON 역직렬화 (fromJson)
│   └── seed/
│       └── database_seeder.dart          # 최초 실행 시 JSON 23개 → SQLite
├── providers/
│   ├── database_provider.dart            # AppDatabase 싱글턴
│   ├── cert_providers.dart               # 자격증 목록/상세/진도 프로바이더
│   └── quiz_providers.dart               # 현재 문제 인덱스, QState 스트림
└── features/
    ├── home/
    │   └── home_screen.dart
    ├── cert_detail/
    │   └── cert_detail_screen.dart
    └── quiz/
        ├── quiz_screen.dart              # 주 학습 화면 (정답 인라인 표시)
        └── explanation_screen.dart       # WrongNote 상세 보기 (showGradeButtons=false)
```

---

## 디자인 토큰 → Flutter 번역

### 색상 (app_colors.dart)

```dart
class AppColors {
  // === DARK THEME ===
  static const darkBg        = Color(0xFF0E1116);
  static const darkSurface   = Color(0xFF161A22);
  static const darkSurface2  = Color(0xFF1E232E);
  static const darkSurface3  = Color(0xFF272D3A);
  static const darkBorder    = Color(0x0FFFFFFF);
  static const darkBorder2   = Color(0x1FFFFFFF);
  static const darkText      = Color(0xFFE7ECF3);
  static const darkTextDim   = Color(0xFF9AA3B2);
  static const darkTextMute  = Color(0xFF5F6878);
  static const darkLime      = Color(0xFFB6F36C);
  static const darkAmber     = Color(0xFFF2B355);
  static const darkRose      = Color(0xFFF2768A);
  static const darkBlue      = Color(0xFF7AB8FF);

  // === LIGHT THEME ===
  static const lightBg       = Color(0xFFF7F8FA);
  static const lightSurface  = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF0F2F5);
  static const lightBorder   = Color(0x14141923);
  static const lightText     = Color(0xFF101521);
  static const lightTextDim  = Color(0xFF5C6677);
  static const lightLime     = Color(0xFF5DA02A);
  static const lightAmber    = Color(0xFFC77A1B);
  static const lightRose     = Color(0xFFD4475F);
}
```

### 타이포그래피
- **한국어 본문**: `GoogleFonts.notoSansKr()`
- **숫자/모노**: `GoogleFonts.jetBrainsMono()`
- 화면 좌우 패딩: 14px, 카드 반경: 12px, 버튼 높이: 52~56px

---

## 데이터 스키마 (JSON → SQLite)

### JSON 파일 구조

```json
{
  "cert_id": "forklift",
  "cert_name": "지게차운전기능사",
  "category": "건설기계",
  "total_items": 365,
  "items": [
    {
      "id": 2,
      "question": "지게차의 화물 운반 방법은?",
      "answer": "운반 중 마스트를 뒤로 4도 가량...",
      "ai_explanation": {
        "background": "...",
        "concept": "...",
        "exam_tip": "...",
        "memory_tip": "..."
      },
      "difficulty": 1
    }
  ]
}
```

### Drift 테이블 (P0: 3개, P1에서 3개 추가 → 총 6개)

```dart
class Certs extends Table {
  TextColumn get certId    => text()();
  TextColumn get certName  => text()();
  TextColumn get category  => text()();
  IntColumn  get totalItems => integer()();
  TextColumn get version   => text().withDefault(const Constant('1.0'))();
  @override Set<Column> get primaryKey => {certId};
}

class Questions extends Table {
  IntColumn  get id             => integer()();
  TextColumn get certId         => text()();
  TextColumn get question       => text()();
  TextColumn get answer         => text()();
  TextColumn get aiExplanation  => text()();  // JSON string
  TextColumn get tags           => text().withDefault(const Constant('[]'))();
  IntColumn  get difficulty     => integer().withDefault(const Constant(1))();
  @override Set<Column> get primaryKey => {id, certId};
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
  @override Set<Column> get primaryKey => {questionId, certId};
}
```

---

## Screen 01 — 홈 (HomeScreen) ✅

**라우트**: `/`

```
AppBar
  title: "자격증 마스터"
  actions: [검색 아이콘 → /search, 설정 아이콘 → /settings]

Body: ListView (카테고리별 그룹)
  CategoryHeader("건설기계")
  CertListTile(cert)
    - 자격증 이름 (16px/600)
    - 카테고리 Chip
    - 문항 수 (11px mono)
    - 진도 바 (4px, lime)
    - 🔥 N일 뱃지 (amber, streak > 0일 때)
```

---

## Screen 02 — 자격증 상세 (CertDetailScreen) ✅

**라우트**: `/cert/:certId`

```
SliverAppBar + 자격증 이름/카테고리/진도율

GridView 2×N (모드 카드)
  "전체학습"   → /cert/:certId/quiz?mode=all    ← (원래 "전체 기출"에서 변경)
  "1분 핵심"   → /cert/:certId/one-min
  "오답·북마크" → /cert/:certId/wrong-note
  "모의고사"   → /mock-exam/:certId
  (나머지 카드는 CertDetail에서 조건부 표시)
```

---

## Screen 03 — 퀴즈 (QuizScreen) ✅

**라우트**: `/cert/:certId/quiz`

> **실제 구현**: 원래 설계(문제만 보여주고 "정답 확인하기" 탭 → ExplanationScreen 이동)와 달리,
> **QuizScreen 한 화면 내에서 인라인으로** 문제 → 정답 공개 → AI 아코디언 → 자가평가까지 처리.

```
TopBar: ← 뒤로가기 | LinearProgressBar | "N/365" (mono)

QuestionCard (surface, radius 12)
  난이도 Chip
  질문 텍스트

[정답 확인하기] 버튼 (lime)
  ↓ 탭 시 인라인으로 아래 섹션 펼침 (ExplanationScreen으로 이동 안 함)

AnswerCard (lime tint)
  answer 텍스트

AccordionList (4섹션)
  📖 배경 / 💡 개념 / 🎯 시험팁 / 🧠 암기팁

BookmarkIcon (toggle) + 북마크 토글 시 DB upsert

StickyBottomBar
  [다시 볼게요] rose   → grade=0, SM-2 계산 → 다음 문제
  [이해했어요]  lime   → grade=2, SM-2 계산 → 다음 문제
```

---

## Screen 04 — 설명 상세 (ExplanationScreen) ✅

**라우트**: `/cert/:certId/explanation?questionId=N`

> **실제 구현**: 주 학습 흐름에서는 사용되지 않고, **WrongNoteScreen에서 문제 탭 시** 열리는 보조 화면.
> `state.extra == false`일 때 `showGradeButtons=false`로 자가평가 버튼 숨김.

```
TopBar: ← 뒤로가기 | LinearProgressBar | "N/365"

QuestionCard  ← showGradeButtons=false일 때만 표시 (WrongNote에서 열 때)

AnswerCard (lime tint)
  "정답" chip  ← showGradeButtons=true일 때만 표시
  answer 텍스트

AccordionList (4섹션) — QuizScreen과 동일

StickyBottomBar (자가평가 버튼) ← showGradeButtons=false면 숨김
```

---

## GoRouter 설정 (현재 전체 12개 라우트)

```dart
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/cert/:certId', builder: ...),
    GoRoute(path: '/cert/:certId/quiz', builder: ...),  // ?mode=all|difficulty
    GoRoute(
      path: '/cert/:certId/explanation',
      builder: (_, state) => ExplanationScreen(
        certId: state.pathParameters['certId']!,
        questionId: int.parse(state.uri.queryParameters['questionId'] ?? '0'),
        showGradeButtons: state.extra != false,  // WrongNote에서 false 전달
      ),
    ),
    GoRoute(path: '/cert/:certId/wrong-note', builder: ...),
    GoRoute(path: '/cert/:certId/one-min', builder: ...),  // stub
    GoRoute(path: '/stats', builder: ...),                 // stub
    GoRoute(path: '/search', builder: ...),
    GoRoute(path: '/settings', builder: ...),
    GoRoute(path: '/mock-exam/:certId', builder: ...),     // stub
    GoRoute(path: '/mock-exam/:certId/active', builder: ...),  // stub
    GoRoute(path: '/mock-exam/:certId/result', builder: ...),  // stub
  ],
);
```

---

## main.dart 실제 구조

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();  // timezone 초기화 포함

  final container = ProviderContainer();
  final db = container.read(databaseProvider);
  await seedIfEmpty(db);  // 최초 실행 시 23개 JSON → SQLite

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CertMasterApp(),
    ),
  );
}
```

---

## P0 검증 체크리스트

```
[x] flutter pub get 성공
[x] dart run build_runner build 성공 (Drift 코드 생성)
[x] 홈 화면에 23개 자격증 표시 (카테고리별 그룹)
[x] 지게차운전기능사 탭 → 자격증 상세 화면
[x] "전체학습" 탭 → 첫 번째 문제 표시
[x] "정답 확인하기" 탭 → 정답 카드 + AI 설명 4섹션 인라인 펼침
[x] "다시 볼게요" 탭 → 다음 문제로 이동 (grade=0 저장)
[x] "이해했어요" 탭 → 다음 문제로 이동 (grade=2 저장)
[x] 다크 테마에서 lime 강조색 정상 표시
[x] 라이트 테마 전환 시 색상 깨짐 없음
```

---

## 중요 제약사항

- **로그인/회원가입 없음** — 완전 로컬
- **객관식 아님** — 사용자가 직접 정답 확인 후 자가평가 (2버튼)
- **알림 권한 요청 금지** — P1에서 첫 자가평가 완료 후 1회만 요청
- **양쪽 테마 모두 구현** — 다크/라이트 전환 시 모든 화면 정상 동작
- **DB migration 미구현** — 개발 중에는 앱 재설치/DB 삭제로 초기화 필요
