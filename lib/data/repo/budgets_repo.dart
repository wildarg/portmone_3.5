import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/get_budget_data_query.dart';
import 'package:portmone_bloc/data/db/query/get_budgets_query.dart';
import 'package:portmone_bloc/data/db/query/get_expense_records.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/budget_info.dart';
import 'package:portmone_bloc/model/expense_record_info.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/money_date_info.dart';
import 'package:portmone_bloc/utils/date_utils.dart';

class BudgetRepo {
  final PortmoneDB db;

  BudgetRepo({required this.db});

  Future<Iterable<MoneyDateInfo>> getBudgetChartData(
    Budget budget,
    DateTime startDate,
    DateTime endDate,
    bool plannedInclude,
  ) async {
    final data = await GetBudgetDataQuery(
      db,
    ).execute(budget, startDate, endDate, plannedInclude);
    final expenses = data
        .map(
          (e) => MoneyDateInfo(
            DateTime.fromMillisecondsSinceEpoch(e.timestamp),
            Money(amountInCents: e.totalCents),
          ),
        )
        .toList();

    return accumulateBudget(startDate, endDate, expenses);
  }

  Iterable<MoneyDateInfo> accumulateBudget(
    DateTime startDate,
    DateTime endDate,
    List<MoneyDateInfo> expenses,
  ) sync* {
    final timeline = DateTimeUtils.iterate(startDate, endDate);
    Money current = const Money(amountInCents: 0);
    int ind = 0;
    for (DateTime d in timeline) {
      while (ind < expenses.length && !expenses[ind].date.isAfter(d)) {
        current += expenses[ind].amount;
        ind++;
      }
      yield MoneyDateInfo(d, current);
    }
  }

  Future<Budget> saveBudget(Budget budget) async {
    final values = {
      BudgetTable.uid: budget.uid,
      BudgetTable.name: budget.name,
      BudgetTable.amount: budget.amount.amountInCents,
      BudgetTable.currencyUid: budget.currency.uid,
    };
    await db.transaction((t) async {
      await t.insert(BudgetTable.tableName, values);
      await t.delete(
        BudgetLinkTable.tableName,
        where: '${BudgetLinkTable.budgetUid} = ?',
        args: [budget.uid],
      );
      await t.batchInsert(
        BudgetLinkTable.tableName,
        budget.expenseTypeUids.map(
          (e) => {
            BudgetLinkTable.budgetUid: budget.uid,
            BudgetLinkTable.expenseTypeUid: e,
          },
        ),
      );
    });

    return budget;
  }

  Future<Iterable<BudgetInfo>> getBudgets(MainFilter filter) {
    final (startDate, endDate) = DateTimeUtils.getBudgetInterval(
      filter.startDate.value,
      filter.endDate.value,
    );
    return GetBudgetsQuery(
      db,
    ).execute(startDate, endDate, filter.plannedInclude);
  }

  Future<Budget> deleteBudget(Budget budget) async {
    await db.exec([
      "delete from ${BudgetTable.tableName} where ${BudgetTable.uid} = '${budget.uid}'",
      "delete from ${BudgetLinkTable.tableName} where ${BudgetLinkTable.budgetUid} = '${budget.uid}'",
    ]);
    return budget;
  }

  Future<Iterable<ExpenseRecordInfo>> getExpenseRecordInfo(MainFilter filter) {
    final (startDate, endDate) = DateTimeUtils.getBudgetInterval(
      filter.startDate.value,
      filter.endDate.value,
    );
    return GetExpenseRecordsQuery(
      db,
    ).execute(startDate, endDate, filter.plannedInclude);
  }
}
