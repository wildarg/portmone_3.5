
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/account_ranged_info.dart';
import 'package:portmone_bloc/model/amount_type_info.dart';
import 'package:portmone_bloc/model/currency.dart';
import 'package:portmone_bloc/model/currency_info.dart';
import 'package:portmone_bloc/model/currency_range_info.dart';
import 'package:portmone_bloc/model/date_transactions.dart';
import 'package:portmone_bloc/model/expense_draft.dart';
import 'package:portmone_bloc/model/income_draft.dart';
import 'package:portmone_bloc/model/transfer_draft.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/model/operation_type.dart';

sealed class PortmoneAction {}

class InitAction extends PortmoneAction {}


// Database actions
class BackupDbAction extends PortmoneAction {}
class RestoreDbAction extends PortmoneAction {}


// Main Filter actions
class SetMainFilterAction extends PortmoneAction {
  final MainFilter filter;
  SetMainFilterAction({required this.filter});
}

class SetAccountFilterAction extends PortmoneAction {
  final Account? account;
  SetAccountFilterAction(this.account);
}

class SetTextFilterAction extends PortmoneAction {
  final String text;
  SetTextFilterAction(this.text);
}

class UpdateMainFilterAction extends PortmoneAction {
  final MainFilter filter;
  UpdateMainFilterAction({required this.filter});
}


class RefreshAccounts extends PortmoneAction {}

class SetAccountsAction extends PortmoneAction {
  final List<Account> accounts;
  SetAccountsAction(this.accounts);
}

class SaveAccountAction extends PortmoneAction {
  final Account account;
  SaveAccountAction(this.account);  
}

class SetAccountOrderAction extends PortmoneAction {
  final List<Account> accounts;
  SetAccountOrderAction(this.accounts);
}


class SetCurrencyListAction extends PortmoneAction {
  final List<Currency> list;
  SetCurrencyListAction(this.list);
}

class SetIncomeTypesAction extends PortmoneAction {
  final List<TransactionType> list;
  SetIncomeTypesAction(this.list);
}

class SetExpenseTypesAction extends PortmoneAction {
  final List<TransactionType> list;
  SetExpenseTypesAction(this.list);
}

class SetTagsAction extends PortmoneAction {
  final List<String> list;
  SetTagsAction(this.list);
}

// transaction actions
class RefreshJournalAction extends PortmoneAction {}


class SaveExpenseAction extends PortmoneAction {
  final ExpenseDraft draft;
  SaveExpenseAction(this.draft);
}


class SaveIncomeAction extends PortmoneAction {
  final IncomeDraft draft;
  SaveIncomeAction(this.draft);
}

class SaveTransferAction extends PortmoneAction {
  final TransferDraft draft;
  SaveTransferAction(this.draft);
}

// Reports actions
class SetTotalReportAction extends PortmoneAction {
  final List<CurrencyRangeInfo> data;
  SetTotalReportAction({required this.data});
}

class RefreshAccountBalanceReportAction extends PortmoneAction {}

class SetAccountBalanceReportAction extends PortmoneAction {
  final List<AccountRangedInfo> data;
  SetAccountBalanceReportAction({required this.data});
}

class SetTotalExpenseReportAction extends PortmoneAction {
  final List<CurrencyInfo> data;
  SetTotalExpenseReportAction({required this.data});
}

class SetTypeExpenseReportAction extends PortmoneAction {
  final List<AmountTypeInfo> data;
  SetTypeExpenseReportAction(this.data);
}

class SetTotalIncomeReportAction extends PortmoneAction {
  final List<CurrencyInfo> data;
  SetTotalIncomeReportAction({required this.data});
}

class SetTypeIncomeReportAction extends PortmoneAction {
  final List<AmountTypeInfo> data;
  SetTypeIncomeReportAction(this.data);
}

class SetJournalAction extends PortmoneAction {
  final List<DateTransactions> journal;
  SetJournalAction(this.journal);
}