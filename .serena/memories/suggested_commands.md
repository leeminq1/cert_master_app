# Suggested commands

- `flutter pub get` - fetch dependencies.
- `dart run build_runner build` - regenerate Drift/Riverpod generated files when annotated database/DAO/provider code changes.
- `flutter analyze` - static analysis; currently passes.
- `flutter test` - run tests; currently only placeholder widget test exists and passes.
- `flutter run` - run the app on an emulator/device.

Windows/Powershell utilities:
- `Get-ChildItem -Recurse -File` for file discovery when `rg` is unavailable or blocked.
- `Select-String -Path ... -Pattern ...` for text search.
- `Get-Content -LiteralPath <path> -Encoding UTF8` for Korean markdown/source files.