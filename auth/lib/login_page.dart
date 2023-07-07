import 'package:auth/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reusable login page UI
class LoginPage extends ConsumerWidget {
  const LoginPage({
    required this.aboutTheApp,
    required this.screenTitle,
    Key? key,
  }) : super(key: key);

  final String screenTitle;
  final Widget aboutTheApp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    bool isWideScreen = screenSize.width >= screenSize.height;

    return Container(
      color: Colors.white,
      child: isWideScreen ? _buildWideScreen() : _buildNarrowScreen(),
    );
  }

  //used when screen width >= screen height
  Widget _buildWideScreen() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: LoginWidget(screenTitle: screenTitle),
          ),
        ),
        Expanded(child: aboutTheApp)
      ],
    );
  }

  //used when screen height > screen width
  Widget _buildNarrowScreen() {
    return ListView(
      children: [
        aboutTheApp,
        LoginWidget(
          screenTitle: screenTitle,
        ),
      ],
    );
  }
}
