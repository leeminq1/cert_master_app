# Completion checklist

For implementation tasks, run at minimum:

1. `flutter analyze`
2. `flutter test`

If Drift tables/DAOs or generated providers changed, also run:

1. `dart run build_runner build`
2. Then rerun `flutter analyze` and `flutter test`.

For UI changes, manually run the app or inspect screenshots where possible, especially because the design handoff requires dark/light fidelity and Korean text wrapping.