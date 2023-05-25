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

    return isWideScreen ? _buildWideScreen() : _buildNarrowScreen();
  }

  Widget _buildWideScreen() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoginButtonsWidget(
                screenTitle: screenTitle,
              )
            ],
          )),
          Expanded(child: Center(child: aboutTheApp))
        ]);
  }

  Widget _buildNarrowScreen() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              aboutTheApp,
              LoginButtonsWidget(
                screenTitle: screenTitle,
              ),
            ]),
          ))
        ]);
  }
}
