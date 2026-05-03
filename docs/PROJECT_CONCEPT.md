# CertMaster (자격증마스터) — 프로젝트 컨셉 문서

> 최종 업데이트: 2026-05-03

---

## 1. 프로젝트 개요

| 항목 | 내용 |
|---|---|
| **앱 이름** | CertMaster (자격증마스터) |
| **패키지명** | `cert_master` |
| **플랫폼** | Android (Google Play) — Flutter 기반 |
| **수익 모델** | AdMob (배너 + 전면 + 보상형 광고) — 미구현 |
| **아키텍처** | Offline-first, No-backend (서버비 0원) |
| **핵심 컨셉** | 23개 자격증 핵심 개념 플래시카드 + AI 해설 + SM-2 복습 스케줄링 앱 |

---

## 2. 현재 구현 상태 스냅샷 (2026-05-03)

### 완료된 기능 (P0 + P1)

| 화면/기능 | 상태 | 비고 |
|---|---|---|
| HomeScreen | ✅ 완료 | 카테고리 그룹, 진행률 바, 스트릭 뱃지 |
| CertDetailScreen | ✅ 완료 | 6개 모드 카드 |
| QuizScreen | ✅ 완료 | 인라인 정답/AI 아코디언/북마크/2버튼 자가평가 |
| ExplanationScreen | ✅ 완료 | WrongNote 상세뷰 전용 (`showGradeButtons=false`) |
| WrongNoteScreen | ✅ 완료 | 2탭 (다시보는 개념 / 북마크), ✕ 삭제 버튼 |
| SearchScreen | ⚠️ 부분 구현 | 자격증명 검색만 구현, 문항 FTS5 검색 미구현 |
| SettingsScreen | ⚠️ 부분 구현 | 테마 토글, 알림 토글, 일일 알림 시간 피커 구현. 백업/복원/초기화 미구현 |
| StatsScreen | ❌ stub | "P2에서 구현" placeholder |
| OneMinCoreScreen | ❌ stub | "P2에서 구현" placeholder |
| MockExam 3종 | ❌ stub | "P2에서 구현" placeholder |
| SM-2 알고리즘 | ✅ 완료 | grade 0/2만 UI 노출 (grade 1은 SM-2 함수에만 존재) |
| 스트릭 | ✅ 완료 | `DailyActivities` 테이블 기반 연속 학습일 계산 |
| 로컬 알림 | ✅ 완료 | 3일 미접속 알림, SM-2 복습 알림, 일일 목표 알림 |
| 테마 저장 | ✅ 완료 | Settings 테이블 `theme_mode` 키 |
| 진도 재개 | ✅ 완료 | Settings 테이블 `quiz_last_index_{certId}` 키 |

### 미구현 (P2)
- 1분핵심 인터랙티브 카드 뷰
- 통계 히트맵 / 예상 점수
- 문항 FTS5 전문 검색
- 모의고사 (타이머 + 60문항)
- JSON 백업 / 복원
- 학습 기록 초기화
- AdMob 광고 연동

---

## 3. 비즈니스 전략

### 타겟 유저
- 20~50대 자격증 수험생 (기능사/산업기사/기사)
- 출퇴근 시간에 모바일로 암기 학습하는 직장인
- 시험 직전 요점 복습이 필요한 수험생

### 경쟁 우위
| 기존 앱 (CBT류) | CertMaster |
|---|---|
| 기출문제 4지선다 풀이 | **핵심 개념 플래시카드 + AI 해설** |
| 단순 정답 확인 | 배경, 개념, 시험팁, 암기법 4단계 해설 |
| 인터넷 필요 | **완전 오프라인** |
| 광고 많음 | 학습 흐름을 방해하지 않는 광고 배치 (예정) |

---

## 4. 데이터 파이프라인

### 4.1 데이터 소스
- **출처:** 네이버 블로그 cgt0203 (자격증 요점정리 카테고리)
- **수집 방식:** Selenium 크롤링 → `◎ 질문? 답변` 패턴 파싱 → JSON 변환
- **수집 스크립트:** `scripts/parse_blog.py`

### 4.2 수집된 데이터 (23개 자격증, 5,983항목)

| 분야 | 자격증 | 파일명 | 항목수 |
|---|---|---|---|
| 건설기계 | 지게차운전기능사 | `forklift.json` | 365 |
| 건설기계 | 굴삭기운전기능사 | `excavator.json` | 231 |
| 금속/용접 | 용접산업기사 | `welding.json` | 222 |
| 자동차 | 자동차정비기사 | `auto_mechanic.json` | 260 |
| 자동차 | 자동차정비기능사 | `auto_func.json` | 283 |
| 화학/안전 | 위험물산업기사 | `hazmat.json` | 212 |
| 화학/안전 | 위험물기능사 | `hazmat_func.json` | 163 |
| 화학/안전 | 가스기능사 | `gas.json` | 349 |
| 소방/안전 | 소방설비기사(기계) | `fire_mech.json` | 258 |
| 소방/안전 | 소방설비기사(전기) | `fire_elec.json` | 229 |
| 전기/전자 | 전기기사 | `electric_eng.json` | 255 |
| 전기/전자 | 전기산업기사 | `electric_ind.json` | 347 |
| 전기/전자 | 전기기능사 | `electric_func.json` | 278 |
| 전기/전자 | 전자기능사 | `electronics.json` | 417 |
| 기계 | 승강기기능사 | `elevator.json` | 290 |
| 기계 | 공조냉동기계기능사 | `hvac.json` | 320 |
| 식품/조리 | 한식중식양식조리기능사 | `cooking.json` | 227 |
| 식품/조리 | 제빵기능사 | `bread.json` | 194 |
| 식품/조리 | 제과기능사 | `confection.json` | 253 |
| IT | 정보처리기능사 | `it_func.json` | 216 |
| IT | 컴퓨터활용능력2급 | `computer.json` | 177 |
| 사회/복지 | 직업상담사2급 | `career.json` | 177 |
| 농림/환경 | 조경기능사 | `landscape.json` | 260 |

### 4.3 AI 해설 생성
- **API:** Google Gemini Flash (무료 한도)
- **스크립트:** `scripts/add_explanations.py`
- **해설 포맷 (JSON):**
```json
{
  "background": "실무적 배경/중요성 (1문장)",
  "concept": "핵심 개념 쉬운 풀이 (1-2문장)",
  "exam_tip": "시험 출제 포인트 (1문장)",
  "memory_tip": "암기법/연상법 (1문장)"
}
```

---

## 5. 기술 스택 (현재 실제 사용)

| 레이어 | 기술 | 버전 |
|---|---|---|
| 프레임워크 | Flutter | 3.x |
| 언어 | Dart | |
| DB/ORM | Drift (SQLite) | ^2.20.0 |
| SQLite 네이티브 | sqlite3_flutter_libs | ^0.5.0 |
| 상태관리 | flutter_riverpod | ^2.5.0 |
| 라우팅 | go_router | ^13.0.0 |
| 폰트 | google_fonts (NotoSansKr, JetBrainsMono) | ^6.2.0 |
| 알림 | flutter_local_notifications + timezone | ^17.0.0 / ^0.9.0 |
| 차트 | fl_chart | ^0.68.0 (P2 준비 완료) |
| 파일 공유 | share_plus | ^12.0.2 (P2 준비 완료) |
| 파일 선택 | file_picker | ^8.0.0 (P2 준비 완료) |
| 데이터 파이프라인 | Python + Selenium + Gemini API | |

---

## 6. 현재 DB 스키마 (6개 테이블)

```
Certs          — 자격증 메타 (certId PK)
Questions      — 문항 (id+certId PK, aiExplanation JSON)
QStates        — SM-2 학습 상태 (questionId+certId PK)
Attempts       — 풀이 기록 (id autoIncrement)
DailyActivities— 일일 활동 (date+certId PK)
Settings       — 키-값 설정 저장소 (key PK)
```

---

## 7. 현재 라우트 구조 (12개)

```
/                              HomeScreen
/cert/:certId                  CertDetailScreen
/cert/:certId/quiz             QuizScreen (?mode=all|difficulty)
/cert/:certId/explanation      ExplanationScreen (?questionId=N, extra: false = WrongNote 뷰)
/cert/:certId/wrong-note       WrongNoteScreen
/cert/:certId/one-min          OneMinCoreScreen (stub)
/stats                         StatsScreen (stub)
/search                        SearchScreen (자격증명만 검색)
/settings                      SettingsScreen (기본 기능)
/mock-exam/:certId             MockExamSetupScreen (stub)
/mock-exam/:certId/active      MockExamActiveScreen (stub)
/mock-exam/:certId/result      MockExamResultScreen (stub)
```

---

## 8. 개발 로드맵

### P0 — 퀴즈 루프 ✅ 완료
- 홈 → 자격증 선택 → 문제 풀기 → 정답/AI해설 → 자가평가 → 다음 문제
- SQLite 시딩, GoRouter, 다크/라이트 테마

### P1 — 기억 루프 ✅ 완료
- SM-2 복습 스케줄링
- 오답·북마크 화면 (WrongNoteScreen)
- 스트릭 추적
- 로컬 알림 (3일 미접속, SM-2 복습, 일일 목표)
- 테마/알림 설정 (기본)
- 전체학습 진도 재개

### P2 — 나머지 화면 구현 🔜 다음
- StatsScreen (히트맵, 예상 점수)
- OneMinCoreScreen (스토리 스타일 자동 전환)
- 문항 FTS5 전문 검색
- MockExam (60문항 타이머)
- 설정 고도화 (백업/복원, 초기화)
- AdMob 연동 및 출시

### P3 — 수익화
- AdMob 배너/전면/보상형 광고
- Google Play Store 출시
