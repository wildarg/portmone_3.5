import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/expense.dart';
import 'package:portmone_bloc/model/income.dart';
import 'package:portmone_bloc/model/transfer.dart';
import 'package:portmone_bloc/ui/editor/budget/budget_editor.dart';
import 'package:portmone_bloc/ui/editor/expense/expense_editor.dart';
import 'package:portmone_bloc/ui/editor/income/income_editor.dart';
import 'package:portmone_bloc/ui/editor/transfer/transfer_editor.dart';
import 'package:portmone_bloc/ui/home/home_screen.dart';
import 'package:portmone_bloc/ui/settings/dictionary/accounts/accounts_screen.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: null,
  redirect: (context, state) {
    return null;
  },
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'accounts',
      path: '/accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
    GoRoute(
      name: 'expenseEditor',
      path: '/expense/editor', 
      builder: (_, state) => ExpenseEditor(
        expense: state.extra?.takeIfInstance<Expense>(),
      )
    ),
    GoRoute(
      name: 'incomeEditor',
      path: '/income/editor', 
      builder: (_, state) => IncomeEditor(
        income: state.extra?.takeIfInstance<Income>(),
      )
    ),
    GoRoute(
      name: 'transferEditor',
      path: '/transfer/editor', 
      builder: (_, state) => TransferEditor(
        transfer: state.extra?.takeIfInstance<Transfer>(),
      )
    ),
    GoRoute(
      name: 'budgetEditor',
      path: '/budget/editor', 
      builder: (_, state) => BudgetEditor(
        budget: state.extra?.takeIfInstance<Budget>(),
      )
    ),
  ],
);

sealed class NavigationResult {}

class CreateNewTransaction extends NavigationResult {}