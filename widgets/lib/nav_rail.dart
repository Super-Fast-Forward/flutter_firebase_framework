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
  static final SNP<int> selected = snp<int>(0);

  final double? groupAlignment;
  final ValueChanged<int>? onDestinationSelected;
  // final NavigationRailLabelType? labelType;
  final Widget? leading;
  final Widget? trailing;
  // final List<NavigationRailDestination> destinations;
  final Map<String, NavigationRailDestination> destinations;

  NavRail({
    Key? key,
    this.onDestinationSelected,
    this.groupAlignment,
    this.leading,
    this.trailing,
    required this.destinations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build NavRail with ${ref.watch(selected)}');
    return NavigationRail(
        key: key,
        selectedIndex: ref.watch(selected),
        // groupAlignment: groupAligment,
        onDestinationSelected: (int index) {
          ref.read(selected.notifier).value = index;
          print(
              'NavRail: index: $index, name: ${destinations.keys.elementAt(index)}');
          this.onDestinationSelected?.call(index);
        },
        labelType: NavigationRailLabelType.selected,
        // leading: true
        //     ? FloatingActionButton(
        //         elevation: 0,
        //         onPressed: () {
        //           // Add your onPressed code here!
        //         },
        //         child: const Icon(Icons.add),
        //       )
        //     : const SizedBox(),
        // trailing: showTrailing
        //     ? IconButton(
        //         onPressed: () {
        //           // Add your onPressed code here!
        //         },
        //         icon: const Icon(Icons.more_horiz_rounded),
        //       )
        //     : const SizedBox(),
        destinations: destinations.values.toList());
  }
}
