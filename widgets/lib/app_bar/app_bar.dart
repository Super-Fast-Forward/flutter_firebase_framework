import 'package:auth/current_user_avatar_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets/app_bar/theme_switch.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Widget title;
  //all other properties of AppBar widget can be added here
  final Widget userAvatar;
  final Widget themeButton;
  final bool showUserAvatar;
  final bool showThemeButton;

  CustomAppBar({
    Key? key,
    this.title = const Text(''),
    this.showUserAvatar = true,
    this.showThemeButton = true,
    this.userAvatar = const CurrentUserAvatarExtended(),
    this.themeButton = const ThemeSwitch(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: title,
      actions: [
        if (showUserAvatar) userAvatar,
        if (showThemeButton) themeButton
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
