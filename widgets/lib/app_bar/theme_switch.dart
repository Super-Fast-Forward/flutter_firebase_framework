import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/theme.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkState = ref.watch(themeStateNotifierProvider);
    return IconButton(
        tooltip: 'dark/light mode',
        onPressed: () {
          ref.read(themeStateNotifierProvider.notifier).changeTheme();
        },
        icon: Icon(isDarkState == true
            ? Icons.nightlight
            : Icons.nightlight_outlined));
  }
}
