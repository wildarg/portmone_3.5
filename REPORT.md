# Portmone Project Audit Report

Based on the rules defined in `GEMINI.md`, the following issues have been identified in the current project structure and implementation.

## High Severity

1. **Database Schema Uses `REAL` for Monetary Values**
   - **File:** `lib/data/db/scheme.dart`
   - **Description:** The `amount` fields across multiple tables (`ExpensesTable`, `IncomesTable`, `TransfersTable`, `BudgetTable`) are defined as `REAL`.
   - **Violation:** The `GEMINI.md` rule states that SQLite should store "all monetary values as `int` in cents/minor units." `INTEGER` should be used instead of `REAL` to prevent floating-point precision issues and adhere to the project standard.

2. **Usage of `flutter_bloc`**
   - **Files:** `pubspec.yaml`, `lib/store/store_builder.dart`, `lib/store/store_listener.dart`
   - **Description:** The `flutter_bloc` package is included and imported.
   - **Violation:** The project architecture requires a "Custom Redux-like Store" using pure streams and `provider`. `flutter_bloc` is an unnecessary dependency that contradicts this rule.

3. **Usage of Code Generation (`freezed`)**
   - **Files:** `pubspec.yaml`, `lib/model/account.dart`, `lib/model/main_filter.dart` (and their generated `.freezed.dart` counterparts).
   - **Description:** The `freezed` and `freezed_annotation` packages are used to generate domain models.
   - **Violation:** The `GEMINI.md` specifically mandates "Pure domain models with manual `copyWith`. No heavy code-gen."

## Medium Severity

1. **Large UI Component Size**
   - **File:** `lib/ui/core/ui_button.dart`
   - **Description:** This widget file is currently 199 lines long.
   - **Violation:** The guidelines specify that large widgets should be decomposed (`> 150 lines`). While not a critical logic failure, it violates the UI coding standard.
