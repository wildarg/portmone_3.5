import 'package:portmone_bloc/data/db/portmone_db.dart';
import 'package:portmone_bloc/model/account_ranged_info.dart';
import 'package:portmone_bloc/model/money_date_info.dart';
import 'package:portmone_bloc/utils/map_extensions.dart';

class GetAccountRangedBalanceQuery  {

  final PortmoneDB db;

  GetAccountRangedBalanceQuery(this.db);

  Future<Iterable<AccountRangedInfo>> execute(DateTime? startDate, DateTime? endDate, bool includedPending) async {
    final startTimestamp = startDate?.millisecondsSinceEpoch ?? 0;
    final endTimestamp = (endDate ?? DateTime.now()).millisecondsSinceEpoch;

    final sql = getSql(startTimestamp, endTimestamp, includedPending? 1 : 0);
    final list = await db.query(sql);
    final result = list.map((e) => _toBalanceResult(e, startTimestamp, endTimestamp));
    return result;
  }

  AccountRangedInfo _toBalanceResult(
    Map<String, Object?> map,
    int startTimestamp,
    int endTimestamp
  ) {
    return AccountRangedInfo(
      account: map.getAccount(),
      enter: MoneyDateInfo(
        DateTime.fromMillisecondsSinceEpoch(startTimestamp), 
        map.getMoney('enterAmount')
      ),
      exit: MoneyDateInfo( 
        DateTime.fromMillisecondsSinceEpoch(endTimestamp),
        map.getMoney('exitAmount')
      )
    );
  }

  String getSql(int start, int end, int includePlanned) => '''
    with income as (
      select
        t.accountUid,
        sum(case when t.date < $start then t.amount else 0 end) as enterAmount,
        sum(t.amount) as exitAmount
      from 
        incomes t
      where
        planned <= $includePlanned
        and date <= $end
      group by
        1
    ),
    expense as (
      select
        t.accountUid,
        sum(case when t.date < $start then t.amount else 0 end) as enterAmount,
        sum(t.amount) as exitAmount
      from 
        expenses t
      where
        planned <= $includePlanned
        and date <= $end
      group by
        1
    ),
    transfer_to as (
      select
        t.toAccountUid as accountUid,
        sum(case when t.date < $start then t.toAmount else 0 end) as enterAmount,
        sum(t.toAmount) as exitAmount
      from 
        transfers t
      where
        planned <= $includePlanned
        and date <= $end
      group by
        1
    ),
    transfer_from as (
      select
        t.fromAccountUid  as accountUid,
        sum(case when t.date < $start then t.fromAmount else 0 end) as enterAmount,
        sum(t.fromAmount) as exitAmount
      from 
        transfers t
      where
        planned <= $includePlanned
        and date <= $end
      group by
        1
    )
    select
      a.uid as accountUid,
      a.name as accountName,
      a.currencyUid,
      c.name as currencyName,
      sum(
        ifnull(i.enterAmount, 0) -
        ifnull(e.enterAmount, 0) + 
        ifnull(tt.enterAmount, 0) -
        ifnull(tf.enterAmount, 0)
      ) as enterAmount,
      sum(
        ifnull(i.exitAmount, 0) -
        ifnull(e.exitAmount, 0) + 
        ifnull(tt.exitAmount, 0) -
        ifnull(tf.exitAmount, 0)
      ) as exitAmount
    from
      accounts a
      left join currencies c on c.uid = a.currencyUid
      left join income i on i.accountUid = a.uid
      left join expense e on e.accountUid = a.uid
      left join transfer_to tt on tt.accountUid = a.uid
      left join transfer_from tf on tf.accountUid = a.uid
    where
      coalesce(a.archived, 0) = 0  
    group by
      1, 2, 3, 4
    order by
      a.position
  ''';
  
}