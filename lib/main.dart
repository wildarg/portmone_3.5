import 'package:flutter/material.dart';
import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/data/repo/accounts_repo.dart';
import 'package:portmone_bloc/data/repo/currencies_repo.dart';
import 'package:portmone_bloc/data/repo/expense_types_repo.dart';
import 'package:portmone_bloc/data/repo/expenses_repo.dart';
import 'package:portmone_bloc/data/repo/income_types_repo.dart';
import 'package:portmone_bloc/data/repo/journal_repo.dart';
import 'package:portmone_bloc/data/repo/main_filter_repo.dart';
import 'package:portmone_bloc/data/repo/reports_repo.dart';
import 'package:portmone_bloc/data/repo/tags_repo.dart';
import 'package:portmone_bloc/routes/routes.dart';
import 'package:portmone_bloc/store/middleware/accounts_middleware.dart';
import 'package:portmone_bloc/store/middleware/currencies_middleware.dart';
import 'package:portmone_bloc/store/middleware/db_middleware.dart';
import 'package:portmone_bloc/store/middleware/expenses_middleware.dart';
import 'package:portmone_bloc/store/middleware/journal_middleware.dart';
import 'package:portmone_bloc/store/middleware/main_filter_middleware.dart';
import 'package:portmone_bloc/store/middleware/report_middleware.dart';
import 'package:portmone_bloc/store/middleware/tags_middleware.dart';
import 'package:portmone_bloc/store/middleware/transaction_type_middlewares.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/ui/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const PortmoneApp());
}

class PortmoneApp extends StatelessWidget {

  const PortmoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PortmoneDB>(create:(context) => PortmoneDB()),
        Provider<AccountsRepo>(create: (context) => AccountsRepo(db: context.read<PortmoneDB>())),
        Provider<CurrenciesRepo>(create: (context) => CurrenciesRepo(db: context.read<PortmoneDB>())),
        Provider<IncomeTypesRepo>(create: (context) => IncomeTypesRepo(db: context.read<PortmoneDB>())),
        Provider<ExpenseTypesRepo>(create: (context) => ExpenseTypesRepo(db: context.read<PortmoneDB>())),
        Provider<MainFilterRepo>(create: (context) => MainFilterRepo(db: context.read<PortmoneDB>())),
        Provider<ReportsRepo>(create: (context) => ReportsRepo(db: context.read<PortmoneDB>())),
        Provider<JournalRepo>(create: (context) => JournalRepo(db: context.read<PortmoneDB>())),
        Provider<TagsRepo>(create: (context) => TagsRepo(db: context.read<PortmoneDB>())),
        Provider<ExpensesRepo>(create: (context) => ExpensesRepo(db: context.read<PortmoneDB>())),
        Provider<PortmoneStore>(create:(context) => PortmoneStore([
          dbMiddleware(context.read<PortmoneDB>()),
          mainFilterMiddleware(context.read<MainFilterRepo>()),
          accountsMiddlware(context.read<AccountsRepo>()),
          currenciesMiddlware(context.read<CurrenciesRepo>()),
          incomeTypesMiddlware(context.read<IncomeTypesRepo>()),
          expenseTypesMiddlware(context.read<ExpenseTypesRepo>()),
          reportsMiddleware(context.read<ReportsRepo>()),
          journalMiddleware(context.read<JournalRepo>()),
          tagsMiddlware(context.read<TagsRepo>()),
          expensesMiddleware(
            context.read<ExpensesRepo>(),
            context.read<ExpenseTypesRepo>(), 
            context.read<AccountsRepo>(), 
            context.read<CurrenciesRepo>(), 
            context.read<TagsRepo>()
          )
        ]))
      ],
      builder:(context, child) => MaterialApp.router(
        title: 'Portmone App ',
        theme: appTheme,
        
        routerConfig: appRouter,
      ),
    );
  }
}