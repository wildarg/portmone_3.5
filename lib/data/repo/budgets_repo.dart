import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/db/query/get_budget_data_query.dart';
import 'package:portmone_bloc/data/db/query/get_budgets_query.dart';
import 'package:portmone_bloc/data/db/scheme.dart';
import 'package:portmone_bloc/model/budget.dart';
import 'package:portmone_bloc/model/budget_info.dart';
import 'package:portmone_bloc/model/money.dart';
import 'package:portmone_bloc/model/money_date_info.dart';
import 'package:portmone_bloc/utils/date_utils.dart';

class BudgetRepo {

  final PortmoneDB db;

  BudgetRepo(this.db);

  Future<Iterable<MoneyDateInfo>> getBudgetChartData(
    Budget budget, 
    DateTime startDate, 
    DateTime endDate, 
    bool plannedInclude
  ) async {
    final data = await GetBudgetDataQuery(db).execute(budget, startDate, endDate, plannedInclude);
    final expenses = data.map((e) => 
      MoneyDateInfo(
        DateTime.fromMillisecondsSinceEpoch(e.timestamp), 
        Money(amountInCents: e.totalCents)
      )
    ).toList();

    return _accumulateBudget(
      DateTimeUtils.iterate(startDate, endDate), 
      expenses
    );
  }

  Iterable<MoneyDateInfo> _accumulateBudget(Iterable<DateTime> timeline, List<MoneyDateInfo> expenses) sync* {
    Money current = const Money(amountInCents: 0);
    int ind = 0;
    for (DateTime d in timeline) {
      while (ind < expenses.length && d.isAfter(expenses[ind].date)) {
        current += expenses[ind].amount;
        ind++;
      }
      yield MoneyDateInfo(d, current);
    }
  }

  @override
  Future<Budget> saveBudget(Budget budget) async {
    final values = {
      BudgetTable.uid: budget.uid,
      BudgetTable.name: budget.name,
      BudgetTable.amount: budget.amount.amountInCents,
      BudgetTable.currencyUid: budget.currency.uid,
    };
    await db.insert(BudgetTable.tableName, values);
    await db.delete(
      BudgetLinkTable.tableName, 
      where: '${BudgetLinkTable.budgetUid} = ?', 
      args: [budget.uid]
    );
    await db.batchInsert(
      BudgetLinkTable.tableName, 
      budget.expenseTypeUids.map((e) => {
        BudgetLinkTable.budgetUid : budget.uid,
        BudgetLinkTable.expenseTypeUid : e
      })
    );

    return budget;
  }
  
  Future<Iterable<BudgetInfo>> getBudgets() {
    return GetBudgetsQuery(db).execute();
  }
  
  Future<Budget> deleteBudget(Budget budget) async {    
    await db.exec([
      "delete from ${BudgetTable.tableName} where ${BudgetTable.uid} = '${budget.uid}'",
      "delete from ${BudgetLinkTable.tableName} where ${BudgetLinkTable.budgetUid} = '${budget.uid}'",
    ]);
    return budget;
  }

}

