import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UiIcon extends StatelessWidget {

  final UiIconData icon;
  final double? width;
  final double? height;
  final Color? color;
  final IconThemeData? iconTheme;

  const UiIcon(this.icon, {
    super.key, 
    this.width = 24, 
    this.height, 
    this.color,
    this.iconTheme,
  });

  static ColorFilter? _colorFilter(Color? color) =>
    color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null;
  
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon.path,
      width: width,
      height: height,
      colorFilter: _colorFilter(color ?? icon.color ?? iconTheme?.color ?? IconTheme.of(context).color),  
    );
  }

}

class UiIcons {
  UiIcons._();

  static const String _path = 'assets/icons';

  static const UiIconData portmoneLogo = UiIconData('$_path/portmone_logo.svg');
  static const UiIconData dashboard = UiIconData('$_path/dashboard.svg');
  static const UiIconData dashboardFill = UiIconData('$_path/dashboard-fill.svg');
  static const UiIconData report = UiIconData('$_path/report.svg');
  static const UiIconData reportFill = UiIconData('$_path/report-fill.svg');
  static const UiIconData settings = UiIconData('$_path/settings.svg');
  static const UiIconData search = UiIconData('$_path/search.svg');
  static const UiIconData settingsFill = UiIconData('$_path/settings-fill.svg');
  static const UiIconData wallet = UiIconData('$_path/wallet.svg');
  static const UiIconData wallet2 = UiIconData('$_path/wallet_2.svg');
  static const UiIconData walletFill = UiIconData('$_path/wallet-fill.svg');
  static const UiIconData accounts = UiIconData('$_path/wallet-cards.svg');
  static const UiIconData pending = UiIconData('$_path/pending.svg');
  static const UiIconData calendar = UiIconData('$_path/calendar.svg');
  static const UiIconData dateRange = UiIconData('$_path/date_range.svg');
  static const UiIconData close = UiIconData('$_path/close_small.svg');
  static const UiIconData arrowDropDown = UiIconData('$_path/arrow_drop_down.svg');
  static const UiIconData arrowDropUp = UiIconData('$_path/arrow_drop_up.svg');
  static const UiIconData arrowForward = UiIconData('$_path/arrow_forward.svg');
  static const UiIconData arrowUpward = UiIconData('$_path/arrow_upward.svg');
  static const UiIconData arrowDownward = UiIconData('$_path/arrow_downward.svg');
  static const UiIconData trendingUp = UiIconData('$_path/trending_up.svg');
  static const UiIconData trendingDown = UiIconData('$_path/trending_down.svg');
  static const UiIconData filter = UiIconData('$_path/funnel-light.svg');
  static const UiIconData trash = UiIconData('$_path/trash.svg');
  static const UiIconData copy = UiIconData('$_path/copy.svg');
  static const UiIconData more = UiIconData('$_path/more.svg');
  static const UiIconData arrowBack = UiIconData('$_path/arrow_back.svg');
  static const UiIconData backup = UiIconData('$_path/backup.svg');
  static const UiIconData restore = UiIconData('$_path/cloud_download.svg');
  static const UiIconData archive = UiIconData('$_path/archive.svg');
  static const UiIconData unarchiveFill = UiIconData('$_path/unarchive-fill.svg');
  static const UiIconData receipt = UiIconData('$_path/receipt.svg');
  static const UiIconData receipt2 = UiIconData('$_path/receipt_2.svg');
  static const UiIconData currencyExchange = UiIconData('$_path/currency_exchange.svg');
  static const UiIconData newBudget = UiIconData('$_path/new_budget.svg');
  static const UiIconData dataThresholding = UiIconData('$_path/data_thresholding.svg');
  static const UiIconData delete = UiIconData('$_path/delete.svg');
}

class UiIconData {
  final String path;
  final Color? color;
  const UiIconData(this.path, {this.color});

  UiIconData copyWith({
    Color? color
  }) {
    return UiIconData(
      path,
      color: color ?? this.color
    );
  }
}
