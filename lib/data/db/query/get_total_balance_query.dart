import 'package:portmone/data/db/portmone_db.dart';
import 'package:portmone/domain/model/amount_currency_info.dart';
import 'package:portmone/domain/model/currency.dart';
import 'package:portmone/domain/model/money.dart';

class GetTotalBalanceQuery  {

  final PortmoneDB db;

  GetTotalBalanceQuery(this.db);

  Future<Iterable<AmountCurrencyInfo>> execute(int? endTimestamp, bool includePlanned) async {
    final sql = getSql(endTimestamp, includePlanned? 1 : 0);
    final list = await db.query(sql);
    final result = list.map(_toBalanceResult);
    return result;
  }

  AmountCurrencyInfo _toBalanceResult(Map<String, Object?> map) {
    return AmountCurrencyInfo(
      currency: Currency(
        uid: map['currencyUid'] as String?,
        name: (map['currencyName'] as String?) ?? '-'
      ),
      amount: Money((map['amount'] as num?)?.toInt() ?? 0),
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
    group by
      1, 2
    order by
      2    
  ''';
  
}