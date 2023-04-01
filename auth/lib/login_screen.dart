import 'package:auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  final String screenTitle;
  final String mainTitle;
  final Map<String, bool> loginOptions;

  const LoginScreen(this.mainTitle, this.screenTitle, this.loginOptions,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isWideScreen = MediaQuery.of(context).size.width >= 800;

    List<Widget> widgets = [
      Expanded(
          flex: isWideScreen ? 1 : 0,
          child: SingleChildScrollView(
              child: LoginButtonsWidget(
            screenTitle: screenTitle,
          ))),
      Expanded(
        flex: isWideScreen ? 1 : 0,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: Colors.blueGrey),
          child: Text(
            mainTitle,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ),
    ];

    return isWideScreen
        ? Flex(direction: Axis.horizontal, children: widgets)
        : SingleChildScrollView(
            child: Flex(
                direction: Axis.vertical, children: widgets.reversed.toList()));
  }
}
