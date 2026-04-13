import 'package:portmone/data/db/portmone_db.dart';

class BalanceResult {
  final String accountUid;
  final String accountName;
  final String? currencyUid;
  final String? currencyName;
  final int amount;

  BalanceResult(
    this.accountUid, 
    this.accountName, 
    this.currencyUid, 
    this.currencyName, 
    this.amount
  );
}

class GetBalanceQuery {

  final PortmoneDB db;

  GetBalanceQuery(this.db);

  Future<Iterable<BalanceResult>> execute(int timestamp, bool includePlanned) async {
    final sql = getSql(timestamp, includePlanned? 1 : 0);
    final list = await db.query(sql);
    final result = list.map(_toBalanceResult);
    return result;
  }

  BalanceResult _toBalanceResult(Map<String, Object?> map) {
    return BalanceResult(
      map['uid'] as String, 
      map['name'] as String, 
      map['currencyUid'] as String?, 
      map['currencyName'] as String?, 
      (map['amount'] as num).toInt(),
    );
  }

  String getSql(int timestamp, int includePlanned) => '''
    with income as (
      select
        t.accountUid,
        sum(t.amount) as amount
      from 
        incomes t
      where
        date <= $timestamp
        and planned <= $includePlanned
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
        date <= $timestamp
        and planned <= $includePlanned
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
        date <= $timestamp
        and planned <= $includePlanned
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
        date <= $timestamp
        and planned <= $includePlanned
      group by
        1
    )
    select
      a.uid,
      a.name,
      a.currencyUid,
      c.name as currencyName,
      ifnull(i.amount, 0) -
      ifnull(e.amount, 0) + 
      ifnull(tt.amount, 0) -
      ifnull(tf.amount, 0) as amount
    from
      accounts a
      left join currencies c on c.uid = a.currencyUid
      left join income i on i.accountUid = a.uid
      left join expense e on e.accountUid = a.uid
      left join transfer_to tt on tt.accountUid = a.uid
      left join transfer_from tf on tf.accountUid = a.uid
  ''';

}