import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_listener.dart';
import 'package:portmone_bloc/ui/core/slidable_fab.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/ui/dashboard/dashboard_screen.dart';
import 'package:portmone_bloc/ui/home/app_bar_content.dart';
import 'package:portmone_bloc/ui/home/banner/filter_banner.dart';
import 'package:portmone_bloc/ui/journal/journal_screen.dart';
import 'package:portmone_bloc/ui/reports/reports_screen.dart';
import 'package:portmone_bloc/ui/settings/settings_screen.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  int _pageInd = 0;
  final PageController _pageController = PageController();

  BannerData? _banner;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late final FabController _fabController;
  late final FocusNode _searchFocusNode;

  final _appDestinations = [
    (page: (BuildContext ctx, [dynamic obj]) => DashboardScreen(), icon: UiIcons.dashboard, selectedIcon: UiIcons.dashboardFill, label: 'Dashboard'),
    (page: (BuildContext ctx, [dynamic obj]) => JournalScreen(searchFocusNode: obj), icon: UiIcons.wallet, selectedIcon: UiIcons.walletFill, label: 'Journal'),
    (page: (BuildContext ctx, [dynamic obj]) => ReportsScreen(), icon: UiIcons.report, selectedIcon: UiIcons.reportFill, label: 'Reports'),
    (page: (BuildContext ctx, [dynamic obj]) => SettingsScreen(), icon: UiIcons.settings, selectedIcon: UiIcons.settingsFill, label: 'Settings'),
  ];

  @override
  void initState() {
    super.initState();

    _searchFocusNode = FocusNode();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // start from right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _fabController = FabController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    _fabController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _updateBanner(MainFilter filter) async {
    _searchFocusNode.unfocus();
    if (filter.account.hasData) {
      setState(() {
        _banner = BannerData(
          title: 'Filtered by account', 
          subtitle: filter.account.value!.fullName
        );
      });
      _controller.forward();
    } else {
      _controller.reverse().whenComplete(() => 
        setState(() {
          _banner = null;
        })
      );      
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _pageInd = index;
    });
    index == 1
      ? _fabController.show() 
      : _fabController.hide();    
    _pageController.jumpToPage(index);
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surfaceContainer,
        title: StoreListener(
          stream: (store) => store.filterState,
          onState: _updateBanner,
          child: AppBarContent()
        ),
        bottom: _banner?.let((data) {
          return PreferredSize(
            preferredSize: Size.fromHeight(90), 
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: FilterBanner(
                  banner: _banner!,
                  onClick: () => context.dispatch(SetAccountFilterAction(null)),
                ),
              ),
            ),
          );
        })
      ),
      backgroundColor: context.colorScheme.surfaceContainer,
      body: PageView.builder(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _appDestinations[index].page(context, _searchFocusNode),
      ),
      floatingActionButton: SlidableFab(
        controller: _fabController, 
        onClick: () {
          _searchFocusNode.unfocus();
        }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(20), // Shadow color and opacity
              spreadRadius: 5, // How widely the shadow is spread
              blurRadius: 7, // How blurred the shadow is
              offset: Offset(0, 3), // Horizontal and vertical offset (x, y)
            ),            
          ]
        ),
        child: NavigationBar(
          selectedIndex: _pageInd,
          onDestinationSelected: _onDestinationSelected,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: _appDestinations.map((d) => NavigationDestination(
            icon: UiIcon(d.icon),
            selectedIcon: UiIcon(d.selectedIcon),
            label: d.label,
          )).toList(),
        ),
      ),
    );
  }
}
