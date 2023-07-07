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
/// This is the login screen

class LoginScreen extends ConsumerWidget {
  final String screenTitle;
  final Widget aboutTheApp;
  final Map<String, bool> loginOptions;
  final Color backgroundColor = //Colors.grey
      Color.fromARGB(255, 48, 48, 48);

  LoginScreen(this.aboutTheApp, this.screenTitle, this.loginOptions, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isWideScreen = MediaQuery.of(context).size.width >= 800;

    return Container(
        color: backgroundColor,
        child: isWideScreen ? _buildWideScreen() : _buildNarrowScreen());
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
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  aboutTheApp,
                  LoginButtonsWidget(
                    screenTitle: screenTitle,
                  ),
                ]),
          ))
        ]);
  }
}
