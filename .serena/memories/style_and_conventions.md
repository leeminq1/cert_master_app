# Style and conventions

- Dart/Flutter project with `flutter_lints` defaults.
- UI uses `GoogleFonts.notoSansKr` for Korean text and `GoogleFonts.jetBrainsMono` for numeric/mono labels.
- Theme tokens live in `lib/core/theme/app_colors.dart`; screens branch manually on `Theme.of(context).brightness` for dark/light colors.
- State management uses Riverpod providers from `lib/providers`.
- Navigation uses GoRouter path strings.
- Persistence uses Drift DAOs and table classes in `lib/data/database`.
- Generated files (`*.g.dart`) are present for Drift and should be regenerated after schema/DAO changes.
- Keep changes narrow and match existing screen-level implementation style.