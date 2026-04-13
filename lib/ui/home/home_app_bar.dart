import 'package:flutter/material.dart';
import 'package:portmone_bloc/model/account.dart';
import 'package:portmone_bloc/model/main_filter.dart';
import 'package:portmone_bloc/store/portmone_actions.dart';
import 'package:portmone_bloc/store/portmone_store.dart';
import 'package:portmone_bloc/store/store_listener.dart';
import 'package:portmone_bloc/ui/home/app_bar_content.dart';
import 'package:portmone_bloc/ui/home/banner/filter_banner.dart';
import 'package:portmone_bloc/utils/common_extensions.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<StatefulWidget> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class _HomeAppBarState extends State<HomeAppBar> with SingleTickerProviderStateMixin  {

  BannerData? _banner;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateBanner(MainFilter filter) async {
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

  @override
  Widget build(BuildContext context) {
    return StoreListener(
      stream: (store) => store.filterState,
      onState: _updateBanner,
      child: AppBar(
        title: AppBarContent(),
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
        }),
      ),
    );
  }
  
}