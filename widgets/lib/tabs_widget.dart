import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsWidget extends ConsumerStatefulWidget {
  final List<String> tabNames;
  final List<Widget> tabWidgets;
  const TabsWidget(this.tabNames, this.tabWidgets, {Key? key})
      : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TabsWidgetState();
  }
}

class _TabsWidgetState extends ConsumerState<TabsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabWidgets.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            child: TabBar(
          // physics: NeverScrollableScrollPhysics(),
          // isScrollable: false,
          controller: _tabController,
          tabs:
              widget.tabNames.map((e) => Tab(text: e)).toList(growable: false),
        )),
        Expanded(
            flex: 10,
            child: Container(
                color: Colors.green,
                child: TabBarView(
                  controller: _tabController,
                  children: widget.tabWidgets
                      .map((widget) => TabContent(child: widget))
                      .toList(growable: false),
                ))),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class TabContent extends StatefulWidget {
  final Widget child;
  TabContent({required this.child, Key? key}) : super(key: key);

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important to call super.build in the build method
    return widget.child;
  }
}
