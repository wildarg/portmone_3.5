import 'package:portmone/data/db/portmone_db.dart';
import 'package:portmone/data/db/scheme.dart';
import 'package:portmone/domain/model/account.dart';
import 'package:portmone/domain/model/account_info.dart';
import 'package:portmone/domain/model/currency.dart';
import 'package:portmone/domain/model/money.dart';

class GetAccountBalanceQuery {

  final PortmoneDB _db;

  GetAccountBalanceQuery(this._db);

  Future<Iterable<AccountInfo>> execute(int? endTimestamp, bool includePlanned) async {
    final sql = getSql(endTimestamp, includePlanned? 1 : 0);
    final list = await _db.query(sql);
    final result = list.map(_toBalanceResult);
    return result;
  }

  AccountInfo _toBalanceResult(Map<String, Object?> map) {
    return AccountInfo(
      account: Account(
        uid: map['uid'] as String,
        name: map['name'] as String,
        currency: _getCurrency(map)
      ),
      amount: Money((map['amount'] as num?)?.toInt() ?? 0)
    );
  }

  Currency? _getCurrency(Map<String, Object?> map) {
    final uid = map['currencyUid'] as String?;
    if (uid == null) return null;
    return Currency(
      uid: uid,
      name: map['currencyName'] as String
    );
  }

  String getSql(int? timestamp, int includePlanned) => '''
    with income as (
      select
        t.accountUid,
        sum(t.amount) as amount
      from 
        incomes t
      where
        planned <= $includePlanned
        ${timestamp != null? 'and date <= $timestamp' : ''}        
      group by
        1
    ),
    expense as (
      select
        t.accountUid,
        sum(t.amount) as amount
      from 
        expenses t
      where
        planned <= $includePlanned
        ${timestamp != null? 'and date <= $timestamp' : ''}        
      group by
        1
    ),
    transfer_to as (
      select
        t.toAccountUid as accountUid,
        sum(t.toAmount) as amount
      from 
        transfers t
      where
        planned <= $includePlanned
        ${timestamp != null? 'and date <= $timestamp' : ''}        
      group by
        1
    ),
    transfer_from as (
      select
        t.fromAccountUid  as accountUid,
        sum(t.fromAmount) as amount
      from 
        transfers t
      where
        planned <= $includePlanned
        ${timestamp != null? 'and date <= $timestamp' : ''}        
      group by
        1
    )
    select
      a.uid,
      a.name,
      a.currencyUid,
      c.name as currencyName,
      sum(
        ifnull(i.amount, 0) -
        ifnull(e.amount, 0) + 
        ifnull(tt.amount, 0) -
        ifnull(tf.amount, 0)
      ) as amount
    from
      accounts a
      left join currencies c on c.uid = a.currencyUid
      left join income i on i.accountUid = a.uid
      left join expense e on e.accountUid = a.uid
      left join transfer_to tt on tt.accountUid = a.uid
      left join transfer_from tf on tf.accountUid = a.uid
    where
      ifNull(a.${AccountsTable.archived}, 0) = 0  
    group by
      1, 2, 3, 4
    order by
      4, 2    
  ''';

}