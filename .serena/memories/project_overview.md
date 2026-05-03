# cert_master overview

Flutter local-first Korean certification study app for 23 certifications. Design handoff lives under `자격증 마스터앱_디자인/design_handoff_cert_master` with HTML/JSX prototype and spec deck. Current app uses Flutter, Drift/SQLite, Riverpod, GoRouter, Google Fonts, local notifications, fl_chart/share/file_picker dependencies.

Code structure: `lib/main.dart` initializes Flutter, NotificationService, ProviderContainer, database seeding, then runs `CertMasterApp`. `lib/app.dart` uses `MaterialApp.router`. Routes live in `lib/core/router/app_router.dart`. UI screens are under `lib/features/*`. Data layer is `lib/data/database` with Drift tables and DAOs; providers are under `lib/providers`.

Current state observed: P0 quiz loop is present, P1 memory-loop pieces are partly implemented (SM-2, q_states, attempts, daily_activity, settings last quiz index, wrong-note/bookmark screen, streak provider, 3-day local reminder). P2 routes/screens exist, but one-min core/stats/settings/mock exam are placeholders; search is implemented only as cert-name search, not FTS question search.