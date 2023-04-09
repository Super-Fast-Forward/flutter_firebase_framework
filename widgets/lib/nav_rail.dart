import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';

///
/// NavigationRail widget with Riverpod state management
///
/// Example:
///
/// ```dart
/// final navRail = NavRail(
///  destinations: {
///   'Home': NavigationRailDestination(
///    icon: const Icon(Icons.home),
///   selectedIcon: const Icon(Icons.home),
///   label: const Text('Home'),
///  ),
/// 'Settings': NavigationRailDestination(
///  icon: const Icon(Icons.settings),
/// selectedIcon: const Icon(Icons.settings),
/// label: const Text('Settings'),
/// ),
/// },
/// );
/// ```
///
class NavRail extends ConsumerWidget {
  // double? groupAlignment,
  // NavigationRailLabelType? labelType,
  // TextStyle? unselectedLabelTextStyle,
  // TextStyle? selectedLabelTextStyle,
  // IconThemeData? unselectedIconTheme,
  // IconThemeData? selectedIconTheme,
  // double? minWidth,
  // double? minExtendedWidth,
  // bool? useIndicator,
  // Color? indicatorColor,

  final Color? backgroundColor;
  final bool? extended;
  final Widget? leading;
  final Widget? trailing;
  final Map<String, NavigationRailDestination> destinations;
  static final SNP<int> selected = snp<int>(0);
  final ValueChanged<int>? onDestinationSelected;
  final double? elevation;
  final double? groupAlignment;
  final NavigationRailLabelType? labelType;
  final TextStyle? unselectedLabelTextStyle;
  final TextStyle? selectedLabelTextStyle;
  final IconThemeData? unselectedIconTheme;
  final IconThemeData? selectedIconTheme;
  final double? minWidth;
  final double? minExtendedWidth;
  final bool? useIndicator;
  final Color? indicatorColor;

  NavRail({
    Key? key,
    this.backgroundColor,
    this.extended,
    this.leading,
    this.trailing,
    required this.destinations,
    this.onDestinationSelected,
    this.elevation,
    this.groupAlignment,
    this.labelType,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.minWidth,
    this.minExtendedWidth,
    this.useIndicator,
    this.indicatorColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('build NavRail with ${ref.watch(selected)}');
    return NavigationRail(
      key: ValueKey('NavigationRail for NavRail ' + key.toString()),
      backgroundColor: backgroundColor,
      extended: extended ?? false,
      leading: leading,
      trailing: trailing,
      destinations: destinations.values.toList(),
      selectedIndex: ref.watch(selected),
      onDestinationSelected: (int index) {
        ref.read(selected.notifier).value = index;
        // print(
        //     'NavRail: index: $index, name: ${destinations.keys.elementAt(index)}');
        this.onDestinationSelected?.call(index);
      },
      elevation: elevation,
      groupAlignment: groupAlignment,
      labelType: labelType,
      unselectedLabelTextStyle: unselectedLabelTextStyle,
      selectedLabelTextStyle: selectedLabelTextStyle,
      unselectedIconTheme: unselectedIconTheme,
      selectedIconTheme: selectedIconTheme,
      minWidth: minWidth,
      minExtendedWidth: minExtendedWidth,
      useIndicator: useIndicator,
      indicatorColor: indicatorColor,
    );
  }
}
