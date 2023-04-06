import 'package:auth/current_user_avatar_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets/app_bar/theme_switch.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<String>? tabs;
  //all other properties of AppBar widget can be added here
  final Widget userAvatar;
  final Widget themeButton;
  final bool showUserAvatar;
  final bool showThemeButton;
  final ValueChanged<String>? onTabSelected;

  CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.tabs,
    this.showUserAvatar = true,
    this.showThemeButton = true,
    this.userAvatar = const CurrentUserAvatarExtended(),
    this.themeButton = const ThemeSwitch(),
    this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: leading,
      title: title == null ? _buildTabBar(context, ref) : title,
      actions: [
        if (showUserAvatar) userAvatar,
        if (showThemeButton) themeButton
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildTabBar(BuildContext context, WidgetRef ref) {
    return tabs == null
        ? Text('no tabs') //Container()
        : Align(
            child: SizedBox(
                width: 800,
                child: TabBar(
                  tabs: tabs!
                      .map((t) => Tab(
                          iconMargin: EdgeInsets.all(0),
                          child:
                              // GestureDetector(
                              //     behavior: HitTestBehavior.translucent,
                              //onTap: () => navigatePage(text, context),
                              //child:
                              Text(
                            t.toUpperCase(),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context).textTheme.titleSmall,
                          )))
                      .toList(),
                  onTap: (index) => onTabSelected?.call(tabs![index]),
                )));
  }
}
