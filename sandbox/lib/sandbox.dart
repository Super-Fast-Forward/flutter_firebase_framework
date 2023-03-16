import 'package:flutter/material.dart';

class Sandbox extends StatelessWidget {
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Widget? child;
  final Function()? toggle;
  const Sandbox(
      {this.child,
      this.themeMode,
      this.theme,
      this.darkTheme,
      this.toggle,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: child ?? Container()),
                    SizedBox(
                        height: 50,
                        child: Flexible(
                            child: ElevatedButton(
                                onPressed: toggle, child: Text('Toggle'))))
                  ],
                ))));
  }
}
