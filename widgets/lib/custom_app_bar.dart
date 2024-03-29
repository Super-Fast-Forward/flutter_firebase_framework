import 'package:auth/current_user_avatar_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TabsAlignment { left, center, right }

/// A custom app bar that can be used in place of the default [AppBar] widget.
/// It can be used to add a [TabBar] to the [AppBar] or to add a [ThemeSwitch] and
/// [CurrentUserAvatarExtended] to the [AppBar] actions.
///
/// Example:
/// ```dart
/// CustomAppBar(
///   tabs: ['Tab 1', 'Tab 2'],
///   onTabSelected: (tab) {
///     print(tab);
///   },
/// )
/// ```
///
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<String>? tabs;
  //all other properties of AppBar widget can be added here
  final Widget userAvatar;
  // final Widget themeButton;
  final Widget? settingsButton;
  final bool showUserAvatar;
  final bool showThemeButton;
  final bool showSettingsButton;
  final double maxTabWidth;
  final TabsAlignment tabsAlignment;
  final Function(BuildContext context, int tabIndex, String tab)? onTabSelected;

  CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.tabs,
    this.showUserAvatar = true,
    this.showThemeButton = true,
    this.showSettingsButton = false,
    this.userAvatar = const CurrentUserAvatarExtended(),
    this.settingsButton,
    this.onTabSelected,
    this.maxTabWidth = 100,
    this.tabsAlignment = TabsAlignment.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: leading,
      title: title == null
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (tabsAlignment == TabsAlignment.right) Spacer(),
                Expanded(
                  child: _buildTabBar(context, ref),
                ),
                if (tabsAlignment == TabsAlignment.left) Spacer(),
              ],
            )
          : title,
      actions: [
        if (showUserAvatar) userAvatar,
        // if (showThemeButton) themeButton,
        if (showSettingsButton && settingsButton != null) settingsButton!
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildTabBar(BuildContext context, WidgetRef ref) {
    return tabs == null
        ? Container()
        :
        // SizedBox(
        //     width: tabs!.length * maxTabWidth,
        //     child:
        // DefaultTabController(
        //     key: ValueKey('DefaultTabController'),
        //     length: tabs!.length,
        //     child:

        Container(
            width: tabs!.length * maxTabWidth,
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: tabs!.length * maxTabWidth,
                ),
                child: TabBar(
                  tabs: tabs!
                      .map((t) => Tab(
                          iconMargin: EdgeInsets.all(0),
                          child: Text(
                            t,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context).textTheme.titleSmall,
                          )))
                      .toList(),
                  onTap: (index) => onTabSelected == null
                      ? Navigator.of(context).pushNamed(
                          '/${tabs![index].toLowerCase().replaceAll(' ', '_')}')
                      : onTabSelected?.call(context, index, tabs![index]),
                )));
  }
}
