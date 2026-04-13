import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portmone_bloc/ui/settings/dictionary/accounts/account_list_tile.dart';
import 'package:portmone_bloc/store/store_builder.dart';
import 'package:portmone_bloc/ui/core/ui_button.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountsScreenState();
  }
  
}

class _AccountsScreenState extends State<AccountsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: UiButton.flatRounded(
          icon: UiIcons.arrowBack,
          onTap: () => context.pop(),
        ),
        title: Text('Accounts'),        
      ),
      body: StoreBuilder(
        stream: (store) => store.accountsState,
        builder:(context, state) {
          return CustomScrollView(
            slivers: [
              SliverList.builder(     
                itemCount: state.length,       
                itemBuilder:(context, index) => AccountListTile(account: state[index])
              )
            ],
          );
        }
      ),
    );
  }


}

