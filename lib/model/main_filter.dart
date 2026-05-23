import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/operation_type.dart';
import 'package:portmone_bloc/utils/nullable.dart';

part 'main_filter.freezed.dart';

@freezed
abstract class MainFilter with _$MainFilter {
  const factory MainFilter({
    required int id,
    required Nullable<DateTime> startDate,
    required Nullable<DateTime> endDate,
    required bool plannedInclude,
    required Nullable<Account> account,
    required Nullable<TransactionType> transactionType,
    required String text,
  }) = _MainFilter;

  static MainFilter empty = MainFilter(
    id: 0,
    startDate: Nullable<DateTime>(null),
    endDate: Nullable<DateTime>(null),
    plannedInclude: false,
    account: Nullable<Account>(null),
    transactionType: Nullable<TransactionType>(null),
    text: ''
  );
}

