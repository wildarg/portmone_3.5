# Project Context & Guidelines: Portmone v3

## 1. Project Overview
Portmone is a personal and family finance tracker for iOS/Android (Flutter) using a pure transaction-based engine. 
- **Core Logic:** No stored intermediate balances. All totals and reports are calculated dynamically from the transaction stream.
- **Transaction Types:** - Income (Credit to account)
  - Expense (Debit from account)
  - Transfer (Double-entry, supports cross-currency with different source/target amounts).
- **Entities:** Accounts (with archiving and manual ordering), Categories (Income/Expense types), Budgets (limits for specific categories), and global Filters.
- **Data Engine:** SQLite (storing all monetary values as `int` in cents/minor units).

## 2. AI Persona & Mindset
- **Role:** Senior Flutter Architect.
- **Tone:** Direct, technical, concise. No fluff.
- **Operation Mode:** **Plan-First.** Propose a technical plan/architecture before generating implementation code.
- **Priority:** Logic integrity and clean code over "messy" UI hacks.

## 3. Architecture & State Management
- **Pattern:** Pragmatic Layered / Feature-First UI.
- **Layers:** - `data/`: `db` (SQL queries) and `repo` (Domain model mediators). No forced interfaces.
    - `model/`: Pure domain models with manual `copyWith`. No heavy code-gen.
    - `ui/`: Feature-based folders. Logic-free widgets.
- **State Management:** Custom Redux-like Store.
    - Single Store with Multiple States (e.g., `filterState`, `journalState`).
    - Flow: `dispatch(Action)` -> `Middleware` (Async/Logic) -> `Reducer` -> `StoreBuilder`.
- **DI:** `Provider` package for injecting the Store and Repositories.
- **Navigation:** `GoRouter`.

## 4. Coding Standards
- **Money:** Always use `int`. Formatting to decimal happens only in UI/Utils.
- **UI:** Decompose large widgets (>150 lines). Use `ui/core` for shared design system components.
- **Extensions:** Use extensions for clean calls (e.g., `context.dispatch`, `context.textTheme`).
- **Formatting:** Use trailing commas.

## 5. Data Management & Backup
- **Backup:** File-based. Share the `Portmone.db` file directly via system share sheet.
- **Restore:** Replace current `Portmone.db` with the selected file and re-initialize the database connection.
- **Integrity:** Ensure the database connection is properly closed/re-opened during the restore lifecycle.

## 6. Testing
- **Policy:** Do not generate tests unless explicitly requested.