import 'package:auth/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// This is the main widget for the login screen.
/// It will display the login buttons on the left and the main title on the right.
///
/// Example:
///  LoginScreen('Login', 'Login Buttons', {
///   'Google': true,
///  'Facebook': true,
/// 'Twitter': true,
/// });
///
class LoginScreen extends ConsumerWidget {
  final String screenTitle;
  final Widget aboutTheApp;
  final Map<String, bool> loginOptions;

  const LoginScreen(this.aboutTheApp, this.screenTitle, this.loginOptions,
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
            child: aboutTheApp),
      ),
    ];

    return isWideScreen
        ? Flex(direction: Axis.horizontal, children: widgets)
        : SingleChildScrollView(
            child: Flex(
                direction: Axis.vertical, children: widgets.reversed.toList()));
  }
}
