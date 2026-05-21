import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portmone_bloc/model/currency.dart';

part 'account.freezed.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String uid,
    required String name,
    required Currency currency,
    @Default(false) bool isArchived,
  }) = _Account;
}

extension AccountExtension on Account {
  String get fullName => '$name, ${currency.name}';
}
