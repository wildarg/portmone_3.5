---
description: Pre-compile check workflow for linting, testing, and compilation
---

This workflow performs standard checks before committing or compiling code.

**Important:** If any errors are found on any step, write them into the `ERRORS.md` file in the project root directory.

// turbo-all
1. Run Dart Linter to check for formatting and static analysis issues:
```bash
flutter analyze
```

2. Run tests to ensure all tests are green:
```bash
flutter test
```

3. Dry-run a build (or run build_runner) to ensure there are no compilation errors. Since this is a Flutter project, we verify that the app can be analyzed and built:
```bash
dart run build_runner build -d
```