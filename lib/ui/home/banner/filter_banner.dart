import 'package:flutter/material.dart';
import 'package:portmone_bloc/ui/core/ui_icon.dart';
import 'package:portmone_bloc/utils/context_extensions.dart';


class BannerData {
  final String title;
  final String subtitle;
  BannerData({required this.title, required this.subtitle});
}

class FilterBanner extends StatelessWidget {

  final BannerData banner;
  final VoidCallback? onClick;

  const FilterBanner({super.key, required this.banner, this.onClick});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),            
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10)
        ),
        color: context.colorScheme.onTertiaryContainer,
        elevation: 6,
        shadowColor: context.colorScheme.tertiary,
        child: ListTile(
          leading: UiIcon(UiIcons.filter, color: context.colorScheme.secondaryContainer),
          title: Text(banner.title, style: context.textTheme.labelMedium?.copyWith(color: context.colorScheme.secondaryContainer)),
          subtitle: Text(banner.subtitle, style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.secondaryContainer)),
          trailing: IconButton(
            onPressed: onClick,
            icon: UiIcon(UiIcons.trash, color: context.colorScheme.onTertiaryContainer),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(context.colorScheme.tertiary)
            ),
          ),
        ),
      ),
    );
  }

}

