# Handoff: 자격증 마스터 (Certification Master) — Local-First Korean Certification Study App

## Overview

A local-first mobile study app for **23 Korean national technical certifications** (지게차운전기능사, 전기기능사, 산업안전기사 등). All study data, notes, scheduling, and notifications happen entirely on the user's device. **No backend, no auth, no sign-up.**

Total content scope: ~9,000 questions across 23 certifications, each with question, answer, and a 4-section AI explanation (background / concept / exam_tip / memory_tip).

## About the Design Files

The files in `design/` are **design references created in HTML + React (Babel-transpiled JSX)** — prototypes showing intended look and behavior. They are **not production code to copy directly**.

Your task is to **recreate these designs in a real mobile codebase**:

- **Recommended:** React Native + Expo + expo-sqlite (or WatermelonDB). The JSX in these files is structurally close to RN — most layouts will translate by replacing `<div>` → `<View>`, `<span>` → `<Text>`, etc.
- **Alternative:** Flutter + drift / sqflite, with the same screen/data structure.

If the project's repo already has an established environment, use its existing patterns and component library; treat this design system as the visual target, not a rigid mandate.

## Fidelity

**High-fidelity (hifi).** Pixel-level decisions are intentional:
- Final colors (dark theme + light theme tokens, both must work)
- Typography pairing (Pretendard for Korean text, JetBrains Mono for numerics/codes)
- Spacing, radii, accent usage
- All screen flows, empty states, and the answer-reveal interaction

Recreate the UI **pixel-perfectly** using the codebase's libraries, but adapt the visual tokens to the platform's idioms (e.g., native iOS/Android components where appropriate).

## What's in this bundle

```
design_handoff_cert_master/
├── README.md                      ← you are here
├── design/
│   ├── main.html                  ← 10-screen design canvas (open in browser)
│   ├── standalone-preview.html    ← single-file offline version of main.html
│   ├── tokens.jsx                 ← color tokens (dark/light) + cert list (23) + sample data
│   ├── phone.jsx                  ← Android phone frame component
│   ├── android-frame.jsx          ← starter device frame
│   ├── design-canvas.jsx          ← starter multi-artboard canvas
│   ├── tweaks-panel.jsx           ← in-design tweak controls (theme/font/layout)
│   ├── screens-1.jsx              ← screens 1-3: Home, Cert Detail, Quiz
│   ├── screens-2.jsx              ← screens 4-6: Explanation, Wrong-note (?), 1-min Core
│   └── screens-3.jsx              ← screens 7-10: Stats, Search, Settings, Mock Exam
└── spec/
    ├── dev-plan.html              ← 17-slide developer spec deck (PRD + DB schema + algorithms + flows)
    └── deck-stage.js              ← deck rendering shell (open dev-plan.html in browser, ←/→ to navigate)
```

**Read order for the developer:**
1. Open `spec/dev-plan.html` in a browser → arrow-key through 17 slides. This is the master spec (data schema, SQLite tables, SM-2 review algorithm, local-push, backup logic, screen flow, edge cases).
2. Open `design/main.html` (or `standalone-preview.html`) in a browser → drag/zoom around 10 phone screens. This is the visual target.
3. Use this README as the synthesis.

## Screens (10 total)

All screens are 360×780 (Android phone, design canvas size). Status bar 9:30 + 87% battery shown for context.

### 01 · Home — `자격증 23개 목록`
- **Purpose:** Top-level navigation. Browse 23 certifications grouped by 5 categories.
- **Layout (toggleable via Tweaks → `homeLayout`):**
  - **List mode** (default): Vertical stack of cert rows. Each row: cert name (16/700), category chip, item count (`365문항` mono), progress bar (4px, lime fill), streak badge if `streak > 0` (amber).
  - **Grid mode**: 2-column grid of cert cards. Each card: 3-letter code (mono, large), name, mini progress ring.
- **Header:** Greeting + streak summary ("🔥 5일 연속") + search bar.
- **Top bar:** "자격증 마스터" title + settings icon (right).

### 02 · Cert Detail — `자격증 상세 (기능 허브)`
- **Purpose:** Hub for a single cert. User picks a study mode.
- **Header:** Cert name (24/800), category chip, total items, % progress with predicted score chip ("예상 60점 · 합격권" if ≥60).
- **Body — 6 mode cards (2×3 grid):**
  1. 전체 기출 (sequential / random toggle inside)
  2. 1분 핵심 (story-mode 8 cards)
  3. 유사 개념 (tag-based clusters)
  4. 오답·북마크 (wrong + bookmarked, with count badge)
  5. 난이도별 (상·중·하 filter)
  6. 모의고사 (60문항 / 60분, only when progress ≥ 30%)
- **Footer:** Category breakdown bar (per-category %).

### 03 · Quiz Screen — `문제 풀이 (정답 가림 상태)`
- **Purpose:** Show ONE question. User reads, thinks, then taps to reveal.
- **Critical interaction:** Questions are **subjective short-answer** (not multiple choice — see below). User does NOT type — they think, tap "정답 확인" button, and the answer slides in.
- **Top bar:** ‹ back, progress bar (lime), `12 / 365` mono.
- **Tags row:** difficulty chip (1/2/3 colored) + content tags (#주행, #안전, #빈출).
- **Question card:**
  - Mono number "Q.12" small
  - Question text (20/600/1.5, max 6 lines, text-wrap pretty)
- **Big primary button (lime, full-width, 56h, radius 14):** "정답 확인하기"
- **Bottom row:** bookmark toggle + skip button.

### 04 · Explanation Screen — `정답 펼침 + AI 해설`
- **State:** After tapping "정답 확인" on screen 03 — same screen extends with answer + explanation.
- **Answer card (lime tinted, prominent):** Full answer text + "정답" label.
- **AI explanation (accordion, 4 sections, all collapsible):**
  1. 📖 배경 (background) — why this matters
  2. 💡 개념 (concept) — the actual content
  3. 🎯 시험팁 (exam_tip) — what comes up on the test
  4. 🧠 암기팁 (memory_tip) — mnemonic, in lime callout
- **Self-grading bar (sticky bottom, 3 buttons):**
  - 🔴 다시 (rose) — wrong / don't know
  - 🟡 애매 (amber) — saw it but unsure
  - 🟢 확실 (lime) — knew it
  - **Action:** writes `attempts` row + updates `q_state` via SM-2 → next question.
- **Related cluster (under accordion):** "유사 개념 5개" card with tag-overlap chips.

### 05 · Wrong Note / Bookmark — `오답노트·북마크`
- **Purpose:** Filtered review of items the user wants to revisit.
- **Segmented control top:** [오답] [북마크] [모름] (3 tabs).
- **Sort:** by wrong-count desc, by recently-attempted, by category.
- **Card list:** Each card shows question preview (2 lines), wrong-count badge (rose), last attempted date, tags. Tap → enters quiz mode filtered to this set.
- **Empty state:** illustration + "아직 오답이 없어요. 오답이 생기면 자동으로 모입니다." + CTA "학습 시작".

### 06 · 1-Min Core — `1분 핵심 몰아보기`
- **Purpose:** Instagram-Stories-style 8-card auto-advancing summary of one category.
- **Top:** segmented progress bars (8 segments, current one filling lime), close (×) button, `4/8` counter.
- **Card (full-bleed, gradient bg):**
  - **Dark theme:** `linear-gradient(170deg, #1a2240, #0E1116 60%)`
  - **Light theme:** `linear-gradient(170deg, surface, surface2 60%)` — must branch on theme!
  - 📌 chip "⚡ 1MIN · CORE" (amber tinted)
  - Huge mono number `04 / 08` (lime, 64px)
  - Concept title (2 lines, 26/700, key phrase in lime)
  - Inner panel with 2-3 bullets (lime/amber dots)
  - Mnemonic callout at bottom (dashed lime border, lime-tinted bg)
- **Bottom:** ‹ 이전 · ⏱ 0:32 / 1:00 · 다음 ›
- **Behavior:** Auto-advance every ~7-8s. Tap left half = previous, right half = next. Tap and hold = pause.

### 07 · Stats — `학습 통계·진도`
- **Hero:** Predicted score (huge, lime if ≥60, amber 40-59, rose <40) + delta vs last week.
- **12-week heatmap:** GitHub-style activity grid (84 cells, lime saturation by `daily_activity.count`).
- **Streak card:** flame icon + "🔥 5일째 연속".
- **Per-category accuracy bars:** horizontal bar list (category name | bar | %).
- **Weakness recommendation:** 3 cards "이 카테고리를 더 풀어보세요" (lowest accuracy first), tap → filtered quiz.

### 08 · Search — `검색`
- **Top:** search input (full-width, surface2 bg, radius 12, 16/500 placeholder).
- **Empty state:** Recent searches chips + "이렇게도 찾아보세요" tag suggestions.
- **Active state:** Real-time SQLite FTS5 results (debounce 200ms). Each result card: highlighted match (`<b>` wrapped), cert name chip, tap → goes to that question.
- **Filter row:** category chips for narrowing.

### 09 · Settings — `설정`
- **Header:** Title "설정" + "모든 기록은 이 기기에만 저장됩니다" subtitle.
- **MY STUDY:** 누적 학습일 / 푼 문항 / 학습중 자격증 (3-stat row).
- **NOTIFICATIONS:** 학습 리마인더 토ggle + time picker, 복습 알림 (3일 미접속), 일일 목표 (slider 5-50).
- **APPEARANCE:** dark/light/auto radio, font scale slider (0.85-1.20), 효과음·진동 toggles.
- **DATA · 로컬 저장소:** Storage usage bar, "콘텐츠 관리", **"학습 기록 JSON 내보내기"** (lime button — primary), "JSON 불러오기", "기출 데이터 업데이트".
- **DANGER ZONE:** "자격증별 진도 초기화", "전체 진도 초기화" (rose).
- **ABOUT:** 버전, 라이선스, 피드백.
- **Footer card:** 🔒 "회원가입 없음 · 외부 전송 없음 · 앱 삭제 전 백업 권장".

### 10 · Mock Exam — `모의고사`
- **Setup screen:** "60문항 · 60분 · 합격선 60점", "시작하기" CTA, 이전 응시 기록.
- **Active screen:** countdown timer top (turns rose under 5 min), question grid drawer (60 cells, color = answered/skipped/empty).
- **Result screen:** Big score, pass/fail chip, per-category breakdown, "틀린 문제 복습" CTA.

## Critical Behaviors

### Question format is short-answer, not MCQ
Source data has `question` + `answer` (free-text). DO NOT build multiple-choice UI. The user reads, thinks privately, taps "정답 확인", reveals the answer, then **self-grades** (다시 / 애매 / 확실). This is faster than typing and matches how Korean cert prep is actually done. Self-grading drives the SRS scheduler.

### SM-2 spaced-repetition (see `spec/dev-plan.html` slide 9)
```
function scheduleReview(s, grade) {
  const now = Date.now();
  let ease = s.ease + (0.1 - (2-grade) * 0.18);
  ease = Math.max(1.3, Math.min(2.8, ease));
  let iv;
  if (grade === 0) { iv = 10/1440; s.wrong_count++; }
  else if (s.interval_days < 1) iv = 1;
  else if (s.interval_days < 3) iv = 3;
  else iv = Math.round(s.interval_days * ease);
  if (grade === 2 && s.last_grade === 2) s.mastery_level = 2;
  else if (grade > 0) s.mastery_level = 1;
  else s.mastery_level = 0;
  return { ...s, ease, interval_days: iv, last_grade: grade, next_review_at: now + iv * 86400000 };
}
```

### Local-first — no backend
- All persistence in SQLite (see `spec/dev-plan.html` slides 7-8 for full schema).
- Local push notifications via `notifee` (RN) / `flutter_local_notifications` (Flutter) — OS scheduler, no FCM/APNs.
- Backup = JSON export to file → OS share sheet (Drive, iCloud, email). Restore = pick file → transactional INSERT.
- DO NOT add any login, account, or remote-sync UI.

## Data Schema

### Content JSON (in-app bundle, seeded to SQLite on first run)
```json
{
  "cert_id": "forklift",
  "cert_name": "지게차운전기능사",
  "category": "건설기계",
  "version": "2026-04-12",
  "items": [{
    "id": 2,
    "question": "지게차의 화물 운반 방법?",
    "answer": "마스트를 뒤로 4도...",
    "ai_explanation": {
      "background": "...", "concept": "...",
      "exam_tip": "...", "memory_tip": "..."
    },
    "tags": ["주행","안전"],
    "difficulty": 1,
    "category": "주행·작동"
  }]
}
```

### SQLite tables
See `spec/dev-plan.html` slides 7-8. Six tables: `certs`, `questions`, `attempts`, `q_state`, `daily_activity`, `settings`. Plus `q_fts` virtual table (FTS5) for search.

## Design Tokens

Both themes are mandatory — user toggles via settings (`auto` follows OS).

### Dark (default)
| Token | Value |
|---|---|
| bg | `#0E1116` |
| surface | `#161A22` |
| surface2 | `#1E232E` |
| surface3 | `#272D3A` |
| border | `rgba(255,255,255,0.06)` |
| borderHi | `rgba(255,255,255,0.12)` |
| text | `#E7ECF3` |
| textDim | `#9AA3B2` |
| textMute | `#5F6878` |
| **lime (primary accent — correct, progress, primary CTAs)** | `#B6F36C` |
| limeDeep | `#7CC23A` |
| **amber (streak, warning, "1MIN" chip)** | `#F2B355` |
| **rose (wrong, danger, error states)** | `#F2768A` |
| blue (info, neutral accent) | `#7AB8FF` |
| diff1 / diff2 / diff3 (difficulty 하/중/상) | `#86E1A6` / `#F2D266` / `#F29C7A` |

### Light
| Token | Value |
|---|---|
| bg | `#F7F8FA` |
| surface | `#FFFFFF` |
| surface2 | `#F0F2F5` |
| surface3 | `#E5E8ED` |
| border | `rgba(20,25,35,0.08)` |
| borderHi | `rgba(20,25,35,0.16)` |
| text | `#101521` |
| textDim | `#5C6677` |
| textMute | `#9098A6` |
| lime | `#5DA02A` |
| limeDeep | `#3F7818` |
| amber | `#C77A1B` |
| rose | `#D4475F` |
| blue | `#2D7CD6` |

### Typography
- **Korean body:** Pretendard (or Pretendard Variable) — fall back to Apple SD Gothic Neo / Noto Sans KR.
- **Numerics, codes, mono:** JetBrains Mono — fall back to SF Mono / ui-monospace.
- **Critical CSS rule everywhere:** `word-break: keep-all; overflow-wrap: break-word;` so Korean phrases don't break mid-word.

### Type scale
| Use | Size / weight / tracking |
|---|---|
| Display (1MIN number) | 64 / 800 / -2 mono |
| H1 (cert name on detail) | 24 / 800 / -0.5 |
| H2 (section) | 20 / 700 / -0.3 |
| Body | 16 / 500 / 0 |
| Body large (question) | 20 / 600 / 0 line-height 1.5 |
| Caption | 13 / 500 |
| Mono label (eyebrow) | 11 / 700 / +1 mono uppercase |

### Spacing & radii
- Base unit: 4. Common: 8, 12, 14, 16, 20, 24, 28, 36.
- Phone screen padding: 14px sides.
- Card radius: 12 (default), 16 (hero), 20 (1MIN card).
- Button radius: 14, height 56 for primary.

## Tech Stack Recommendation

**Primary path: React Native + Expo**
- `expo-sqlite` (or WatermelonDB if perf becomes an issue) — local DB
- `MMKV` or AsyncStorage — kv settings
- `@notifee/react-native` — local push (no FCM)
- `Zustand` or `Jotai` — UI state
- `expo-router` — navigation
- `victory-native` — heatmap & charts
- `expo-file-system` + `expo-sharing` — JSON backup export

**Alternative: Flutter** — see slide 5 of `spec/dev-plan.html`.

## Build Priorities (MVP)

| P0 (week 1) | P1 (week 2) | P2 (week 3) |
|---|---|---|
| Home + Cert Detail | Wrong note + Bookmark | 1MIN core |
| Quiz + Answer reveal | SM-2 review queue | Related/similar concepts |
| Explanation accordion | Streak + daily activity | Mock exam |
| SQLite seed from JSON | Local push registration | Stats + score prediction |

## Critical Don'ts

- ❌ DO NOT add any login, signup, or account UI.
- ❌ DO NOT send any data to any server. (No analytics, no telemetry, no auth.)
- ❌ DO NOT build a multiple-choice UI — the source data is short-answer.
- ❌ DO NOT request notification permission on first app launch — wait until after the user finishes their first quiz session.
- ❌ DO NOT skip transactional handling on backup restore (must roll back on parse error).
- ❌ DO NOT hardcode dark-only colors — every screen must work in both themes (the 1-min gradient on screen 06 is a known trap, see screens-2.jsx for the branching).

## Suggested Claude Code Prompt

```
I'm attaching a design handoff bundle for an app called "자격증 마스터" (Cert Master).

Please:
1. Read README.md fully.
2. Open spec/dev-plan.html in a browser to review the 17-slide developer spec
   (PRD, SQLite schema, SM-2 algorithm, local push, backup, flows, edge cases).
3. Open design/main.html (or design/standalone-preview.html) in a browser to
   review the 10 phone screens.
4. Build the app in React Native + Expo + expo-sqlite, following exactly:
   - The screen layouts in design/main.html
   - The data schema in spec/dev-plan.html slides 6-8
   - The SM-2 algorithm in slide 9
   - The local-push approach in slide 10
   - The backup/restore approach in slide 11

Implementation order: P0 → P1 → P2 from README.

Each milestone, give me a working build I can run on Android via `expo start`.
Write unit tests for scheduling.ts, backup.ts, and streak.ts.
Use TypeScript strict mode.
Treat the HTML/JSX as design references — translate to RN idioms,
don't copy DOM verbatim.
```

## Assets

No raster images / icons used. All UI is type, shape, and color. Icons in the design are inline SVG paths (see `phone.jsx` icon set: x, search, bookmark, clock, chevron, etc.) — the developer should use a real icon library in RN (e.g., `lucide-react-native` or `react-native-vector-icons`) instead of hand-drawing.

## Files at-a-glance

- `design/main.html` — open in browser, drag/zoom around the 10-screen canvas
- `design/standalone-preview.html` — same as above, single-file (works offline, no other files needed)
- `design/tokens.jsx` — copy the `THEMES`, `CERTS`, and `SAMPLE_Q` objects directly
- `design/screens-*.jsx` — read for layout reference, do not copy as production
- `design/tweaks-panel.jsx` — used for in-design experimentation; not needed in shipped app
- `spec/dev-plan.html` — open in browser, ←/→ to navigate 17 slides

---

Questions during implementation? The design canvas (`design/main.html`) and the spec deck (`spec/dev-plan.html`) together are the source of truth. When they conflict, the spec deck wins for behavior and data, the design canvas wins for visuals.
