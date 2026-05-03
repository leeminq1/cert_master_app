# P2 구현 가이드 — 완성 단계 (Polish)

> **전제조건**: P0 + P1 완료 ✅
>
> **목표**: 나머지 stub 화면 구현 + 설정 고도화 + 검색 고도화
>
> **완료 기준**: 모든 화면 정상 동작, JSON 백업 왕복 테스트 통과

---

## ⚠️ 기획 변경 사항 (디자인 대비 코드 최종 결정)

> 원래 design_handoff 기준 CertDetailScreen에 6개 모드 카드가 있었으나,
> 데이터 현실(tags 전부 비어있음, difficulty 전부 1)로 인해 아래 2개 기능을 **영구 제거**함.

| 항목 | 원래 design_handoff | 코드 최종 결정 | 이유 |
|------|-------------------|-----------|----|
| 유사 개념 카드 | 있음 (tags 기반 그룹핑) | **제거** | `tags` 필드가 23개 과목 전부 `[]` — 데이터 없이 구현 불가 |
| 난이도별 카드 | 있음 (difficulty 필터) | **제거** | `difficulty` 필드가 전부 `1` — 의미 있는 필터링 불가 |

**결과**: CertDetailScreen 모드 카드 6개 → 4개 (전체학습 / 1분핵심 / 오답·북마크 / 모의고사)

---

## 현재 stub 상태 화면 (P2 구현 대상)

| 화면 | 라우트 | 현재 상태 |
|---|---|---|
| OneMinCoreScreen | `/cert/:certId/one-min` | ✅ 구현 완료 (2026-05-03) |
| MockExamSetupScreen | `/mock-exam/:certId` | ✅ 구현 완료 (2026-05-03) |
| MockExamActiveScreen | `/mock-exam/:certId/active` | ✅ 구현 완료 (2026-05-03) |
| MockExamResultScreen | `/mock-exam/:certId/result` | ✅ 구현 완료 (2026-05-03) |
| StatsScreen | `/stats` | ❌ "P2에서 구현" placeholder |

## 부분 구현 (P2에서 고도화)

| 화면/기능 | 현재 상태 | P2 목표 |
|---|---|---|
| SearchScreen | ⚠️ 자격증명 검색만 구현 | 문항 FTS5 전문 검색 추가 |
| SettingsScreen | ⚠️ 테마/알림 토글만 구현 | 백업/복원, 초기화, 일일 목표, 폰트 크기 |

---

## P2 추가 패키지

> `fl_chart ^0.68.0`, `share_plus ^12.0.2`, `file_picker ^8.0.0`은 **이미 pubspec.yaml에 포함됨**.
> 추가 설치 불필요.

---

## P2 이미 완료된 인프라 (재사용)

```
lib/data/database/daos/settings_dao.dart    ✅ (P1에서 구현)
lib/providers/settings_providers.dart       ✅ (P1에서 구현 — themeModeProvider, notificationEnabledProvider)
lib/services/notification_service.dart      ✅ (P1에서 구현 — 3종 알림)
lib/core/router/app_router.dart             ✅ P2 라우트 12개 전부 등록됨
```

---

## P2 추가/수정할 파일

```
lib/
├── services/
│   └── backup_service.dart              # JSON 내보내기/불러오기 (신규)
└── features/
    ├── one_min_core/
    │   └── one_min_core_screen.dart     # stub → 구현
    ├── stats/
    │   └── stats_screen.dart           # stub → 구현
    ├── search/
    │   └── search_screen.dart          # 자격증명 검색 → FTS5 문항 검색 추가
    ├── settings/
    │   └── settings_screen.dart        # 기본 구현 → 고도화
    └── mock_exam/
        ├── mock_exam_setup_screen.dart  # stub → 구현
        ├── mock_exam_active_screen.dart # stub → 구현
        └── mock_exam_result_screen.dart # stub → 구현
```

---

## P2 구현 권장 순서

1. **StatsScreen** — DailyActivities 데이터가 이미 쌓이고 있으므로 바로 연결 가능
2. **SettingsScreen 고도화** — 백업/복원/초기화 (BackupService 선행 필요)
3. **SearchScreen FTS5** — app_database.dart에 FTS5 테이블 추가
4. **OneMinCoreScreen** — 독립적, AI해설 데이터 재활용
5. **MockExamScreens** — 가장 복잡 (타이머, 60문항, 결과 계산)

---

## Screen 06 — 1분 핵심 (OneMinCoreScreen)

**라우트**: `/cert/:certId/one-min`

Instagram Stories 스타일의 핵심 개념 카드 자동 전환.

**레이아웃**:
```
TopBar
  8개 세그먼트 진도 바 (현재 것 lime)
  ✕ 닫기
  "4/8" 카운터 (mono)

CardArea (full-bleed)
  배경: 그라디언트 (다크: #1a2240 → #0E1116, 라이트: surface → surface2)
  ⚡ "1MIN · CORE" 칩 (amber)
  "04/08" 대형 숫자 (lime, 64px)
  개념 제목 (26px/700, 키워드 lime)
  불릿 포인트 2~3개 (lime/amber 점)
  암기팁 박스 (dashed lime border)

BottomControls
  "‹ 이전" | "⏱ 0:32/1:00" | "다음 ›"
```

**자동 전환 로직**:
```dart
// 7~8초 자동 전환
// 좌측 절반 탭 = 이전, 우측 절반 탭 = 다음
// 탭 홀드 = 타이머 일시정지
late Timer _autoAdvanceTimer;
bool _isPaused = false;
```

**데이터**: `ai_explanation.memory_tip` + `ai_explanation.concept` 활용.
difficulty=1 문항 중 cert별 상위 8개 선별.

**디자인 참조**: `screens-2.jsx` → `Screen06OneMin`

---

## Screen 07 — 통계 (StatsScreen)

**라우트**: `/stats`

**레이아웃**:
```
AppBar: "학습 통계"

예상 점수 카드
  큰 숫자 (Display, lime≥60 / amber 40~59 / rose <40)
  계산식: (masteryLevel>=3 문항 수 / 전체) × 100

12주 히트맵 (GitHub 잔디밭 스타일)
  7열 × 12행 = 84셀
  lime 채도: 0개=surface2, 1~3=lime_20%, 4~10=lime_50%, 10+=lime_100%
  CustomPainter 또는 GridView로 직접 구현 (fl_chart 부적합)

스트릭 카드
  🔥 N일째 연속

카테고리별 정확도
  수평 막대 (직접 구현 또는 fl_chart)
  오답률 상위 3개 "취약 영역" 추천
```

**데이터 소스**: `DailyActivities` 테이블 (date, count, correctCount), `QStates.masteryLevel`

**히트맵 구현 (CustomPainter)**:
```dart
class HeatmapPainter extends CustomPainter {
  final Map<String, int> activityByDate; // {'2026-05-01': 5, ...}
  // 주별 7일 × 12주 = 84셀 렌더링
}
```

**디자인 참조**: `screens-2.jsx` → `Screen07Stats`

---

## Screen 08 — 검색 (SearchScreen)

**라우트**: `/search`

**현재 구현**: 자격증명 텍스트 필터링만 (`allCertsProvider` 활용).

**P2 추가 구현 — 문항 FTS5 전문 검색**:

```dart
// app_database.dart — onCreate에서 FTS5 가상 테이블 생성
await customStatement('''
  CREATE VIRTUAL TABLE IF NOT EXISTS q_fts USING fts5(
    question, answer, content='questions', content_rowid='rowid'
  )
''');

// 검색 쿼리
final results = await customSelect(
  'SELECT q.* FROM questions q '
  'JOIN q_fts ON q.rowid = q_fts.rowid '
  'WHERE q_fts MATCH ? LIMIT 50',
  variables: [Variable(query)],
  readsFrom: {questions},
).get();
```

**P2 목표 레이아웃**:
```
SearchBar (실시간 debounce 200ms)
  자격증명 검색 결과 (현재 구현)
  + 문항 검색 결과 (P2 추가)
    - 질문 텍스트 (매칭 부분 볼드)
    - 자격증명 Chip / 카테고리 Chip

Empty state: 최근 검색어 Chip, 태그 추천
```

⚠️ **FTS5 추가 시 DB migration 필요** (`schemaVersion` 2로 올리고 migration 작성).

**디자인 참조**: `screens-3.jsx` → `Screen08Search`

---

## Screen 09 — 설정 (SettingsScreen) 고도화

**라우트**: `/settings`

**현재 P1 구현**: 테마 토글, 복습 알림 토글, 매일 알림 토글+시간 피커.

**P2 추가 구현**:

```
Section: MY STUDY (신규)
  오늘 학습 수 / 전체 완료 수 / 연속 학습일 표시

Section: NOTIFICATIONS 고도화
  일일 목표 Slider (5~50문항)

Section: APPEARANCE 고도화
  폰트 크기 Slider (0.85 ~ 1.20)

Section: DATA (신규)
  [학습 기록 JSON 내보내기] lime 버튼
  [JSON 불러오기] 버튼

Section: DANGER ZONE (신규)
  "자격증별 기록 초기화" → 자격증 선택 바텀시트
  "전체 초기화" → 확인 다이얼로그 (rose 강조)

Section: ABOUT (신규)
  버전 정보 / 피드백
  🔒 "회원가입 없음 · 외부 전송 없음"
```

**폰트 크기 반영**:
```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaler: TextScaler.linear(fontScale),
  ),
  child: child,
)
```

**디자인 참조**: `screens-3.jsx` → `Screen09Settings`

---

## JSON 백업/복원 (BackupService)

```dart
// services/backup_service.dart
// 내보내기 구조
{
  "version": "1",
  "exported_at": "2026-05-03T10:00:00",
  "q_states": [...],
  "attempts": [...],
  "daily_activities": [...],
  "settings": {...}
}

// 복원: 트랜잭션으로 원자적 처리, 실패 시 롤백
Future<void> restore(String jsonStr) async {
  await db.transaction(() async {
    await db.deleteAllUserData();  // q_states, attempts, daily_activities, settings
    // ... 각 테이블 복원
  });
}
```

---

## Screen 10 — 모의고사 (MockExamScreens)

**라우트**: `/mock-exam/:certId`, `/mock-exam/:certId/active`, `/mock-exam/:certId/result`

### Setup 화면
```
"60문항 · 60분 · 합격선 60점" 안내
이전 시도 목록 (날짜, 점수)
[시작하기] 버튼
```

### Active 화면
```
TopBar
  ← (중단 확인 다이얼로그)
  타이머 (MM:SS, 5분 미만 시 rose)
  문항 그리드 드로어 토글

QuizCard (QuizScreen 레이아웃과 동일)
  [정답 확인하기] → 해당 문항만 인라인 정답 표시 (기록에 영향 없음)

BottomBar: [이전] [다음] [제출]

문항 그리드 드로어 (60셀)
  답변완료=lime, 건너뜀=amber, 미답변=surface3
```

**60문항 선택**:
```dart
// questions 테이블에서 cert의 무작위 60개 (약점 위주 선택 권장)
final questions = await db.questionDao.getRandomQuestions(certId: certId, limit: 60);
```

**타이머**:
```dart
Duration _remaining = const Duration(minutes: 60);
// 시간 종료 시 자동 제출, 5분 미만 시 timerColor = rose
```

### Result 화면
```
큰 점수 표시 (Display 폰트)
합격/불합격 Chip (lime=합격≥60, rose=불합격)
카테고리별 정답률 바
[틀린 문제 복습] → WrongNoteScreen
[다시 도전] → Setup 화면
```

**디자인 참조**: `screens-3.jsx` → `Screen10MockExam`

---

## 엣지 케이스 처리

| 케이스 | 처리 방법 |
|--------|-----------|
| JSON 시딩 중 앱 종료 | `seeded` 설정이 `'1'`이 아니면 재시딩 (현재는 certs 테이블 count로 판별) |
| 문항 0개인 자격증 | "준비 중" 상태 표시 (CertDetailScreen) |
| FTS5 검색 결과 없음 | Empty state + 다른 키워드 안내 |
| 백업 JSON 파싱 오류 | 오류 메시지 + 트랜잭션 롤백 |
| 모의고사 중 앱 종료 | 재진입 시 중단 지점 복구 (임시 저장 — 구현 시 결정) |
| 알림 권한 거부 | 재요청 없이 조용히 skip (설정 화면에서 재시도 가능) |
| DB migration | `schemaVersion` 올릴 때 `MigrationStrategy` 작성 필요. 현재는 개발 중 재설치로 대응. |

---

## P2 Settings 테이블 추가 키 (예정)

> P1에서 실제 사용하는 키는 plan-p1.md 참조. 아래는 P2에서 추가될 키.

| 키 | 값 형식 | 사용처 |
|---|---|---|
| `font_scale` | `'1.0'` | 폰트 크기 슬라이더 |
| `daily_goal` | `'20'` | 일일 목표 문항 수 |
| `sound_enabled` | `'true'`\|`'false'` | 소리 토글 |
| `vibration_enabled` | `'true'`\|`'false'` | 진동 토글 |

---

## GoRouter P2 라우트 (이미 등록됨)

```dart
// app_router.dart에 이미 포함 — 추가 작업 불필요
GoRoute(path: '/stats', ...),
GoRoute(path: '/search', ...),
GoRoute(path: '/settings', ...),
GoRoute(path: '/mock-exam/:certId', ...),
GoRoute(path: '/mock-exam/:certId/active', ...),
GoRoute(path: '/mock-exam/:certId/result', ...),
```

---

## P2 검증 체크리스트

```
[ ] 1분핵심: 카드 7~8초 자동 전환
[ ] 1분핵심: 좌측 탭=이전, 우측 탭=다음, 홀드=일시정지
[ ] 통계: 12주 히트맵 84셀 렌더링 (다크/라이트 양쪽)
[ ] 통계: 예상 점수 (masteryLevel≥3 기준) 색상 lime/amber/rose
[ ] 검색: 자격증명 검색 (기존 유지)
[ ] 검색: 문항 FTS5 '마스트' 검색 → 지게차 관련 문항 실시간 표시
[ ] 설정: JSON 내보내기 → 파일 저장/공유
[ ] 설정: 초기화 → JSON 불러오기 → 데이터 완전 복구
[ ] 설정: 전체 초기화 확인 다이얼로그 → rose 강조 표시
[ ] 모의고사: 60문항 타이머 60분 카운트다운
[ ] 모의고사: 5분 미만 타이머 rose 색상
[ ] 모의고사: 완료 후 점수 + 합격/불합격 표시
[ ] 전체 화면 다크/라이트 정상
[ ] 한국어 텍스트 줄바꿈 정상
```

---

## P2 완료 후 출시 체크리스트

```
[ ] flutter build apk --release 성공
[ ] 앱 이름: "자격증 마스터"
[ ] 앱 아이콘 설정 (flutter_launcher_icons)
[ ] 스플래시 스크린 설정 (flutter_native_splash)
[ ] AndroidManifest.xml: 알림 권한 선언
[ ] AndroidManifest.xml: 인터넷 권한 없음 확인 (오프라인 전용)
[ ] 최소 Android SDK 21 이상 확인
[ ] ProGuard/R8 Drift 예외 규칙 확인
[ ] AdMob 연동 (배너/전면/보상형)
```
