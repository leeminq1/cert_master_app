# CLAUDE.md — 자격증 마스터 (Cert Master)

This is a **design handoff package** for a Korean national-certification study app.

## Read these first, in order

1. **`README.md`** in this folder — full implementation guide (screens, tokens, behaviors, don'ts).
2. **`spec/dev-plan.html`** — open in a browser, navigate with ←/→. 17 slides covering:
   - Product vision (slides 1-2)
   - 23 cert content scope (slide 3)
   - 9 features map (slide 4)
   - Tech stack (slide 5)
   - Content JSON schema (slide 6)
   - SQLite schema — content tables (slide 7)
   - SQLite schema — user data tables (slide 8)
   - SM-2 review algorithm with code (slide 9)
   - Streak + score prediction (slide 10)
   - Local push notifications (slide 11)
   - Backup/restore JSON (slide 12)
   - FTS5 search + tag-based related (slide 13)
   - Screen flows (slide 14)
   - Question state machine (slide 15)
   - Edge cases (slide 16)
   - Handoff checklist (slide 17)
3. **`design/main.html`** — open in a browser. Pan/zoom the canvas to inspect 10 phone screens. Click any artboard to focus.
4. **`design/standalone-preview.html`** — same as main.html but offline-bundled. Use this if main.html breaks (no internet for fonts, etc.).

## Reference files (do not edit, do not ship)

- `design/tokens.jsx` — copy `THEMES`, `CERTS`, `SAMPLE_Q` data structures directly
- `design/screens-*.jsx` — JSX layout reference, translate idioms to React Native
- `design/phone.jsx`, `design/android-frame.jsx` — phone bezel for canvas; do not need in shipped app
- `design/tweaks-panel.jsx`, `design/design-canvas.jsx` — design canvas tooling, not for shipping
- `spec/deck-stage.js` — supporting file for dev-plan.html only

## Hard rules (do not violate)

- **No backend.** No login, no auth, no remote calls, no analytics. Local-first.
- **Short-answer, not MCQ.** User reads → taps "정답 확인" → reveals answer → self-grades (다시/애매/확실).
- **Both themes mandatory.** Every screen tested in dark and light.
- **Korean text breaking:** every text node needs `word-break: keep-all; overflow-wrap: break-word;` (or RN equivalent — likely no-op since RN handles this).
- **Notification permission:** request only after first quiz completes, never at app launch.
- **Backup restore:** transactional. Roll back on parse error or schema mismatch.

## Recommended stack

React Native + Expo + TypeScript strict + expo-sqlite + @notifee/react-native + Zustand + expo-router.

Alternative: Flutter + drift + flutter_local_notifications + Riverpod + go_router.

Pick one and stick with it.

## Build sequence

| Milestone | Includes | Verifies |
|---|---|---|
| **P0** Quiz loop | SQLite seed, Home, Cert Detail, Quiz, Answer reveal, Explanation accordion | A user can pick a cert and grind through questions |
| **P1** Memory loop | Wrong note, Bookmark, SM-2 scheduler, Streak, Daily activity | Spaced repetition actually scheduled and surfaced |
| **P2** Polish | 1-min Core (auto-advancing stories), Related, Mock Exam, Stats, Settings, Backup, Search | Feature-complete MVP |

Ship a runnable Android build at the end of each milestone via `expo start`.

## When the design and spec disagree

- Visual / layout / typography / color → **design canvas wins**.
- Behavior / data shape / algorithm → **spec deck wins**.

## Suggested first command

```
Read README.md, open spec/dev-plan.html and design/main.html in a browser,
then propose a folder structure for the React Native app and start with P0.
```
