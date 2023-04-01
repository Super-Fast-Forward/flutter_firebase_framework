import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavRailTab { machine, library, store, pub, config }

extension NavRailTabExtension on NavRailTab {
  String get name => toString().split('.').last;
}

class NavRail extends ConsumerWidget {
  final int selectedIndex;
  // final double groupAlignment;
  // final ValueChanged<int> onDestinationSelected;
  // final NavigationRailLabelType labelType;
  // final Widget leading;
  // final Widget trailing;
  // final List<NavigationRailDestination> destinations;
  static final List<String> _tabs = [
    NavRailTab.machine.name,
    NavRailTab.library.name,
    NavRailTab.store.name,
    NavRailTab.pub.name,
  ];

  const NavRail({
    Key? key,
    required this.selectedIndex,
    // required this.groupAlignment,
    // required this.onDestinationSelected,
    // required this.labelType,
    // required this.leading,
    // required this.trailing,
    // required this.destinations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      // groupAlignment: groupAligment,
      onDestinationSelected: (int index) {
        // setState(() {
        //   _selectedIndex = index;
        // });
        Navigator.of(context).pushNamed(_tabs[index]);
      },
      labelType: NavigationRailLabelType.selected,
      // leading: showLeading
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
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.reorder),
          // selectedIcon: Icon(Icons.favorite),
          label: Text('Flows'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bookmark),
          selectedIcon: Icon(Icons.bookmark),
          label: Text('Custom Execs'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.house),
          selectedIcon: Icon(Icons.house),
          label: Text('Store'),
        ),
        // NavigationRailDestination(
        //   icon: Icon(Icons.star_border),
        //   selectedIcon: Icon(Icons.star),
        //   label: Text('Third'),
        // ),
      ],
    );
  }
}
