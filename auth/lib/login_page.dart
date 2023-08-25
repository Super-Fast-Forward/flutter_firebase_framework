import 'package:auth/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reusable login page UI
class LoginPage extends ConsumerWidget {
  const LoginPage({
    required this.aboutTheApp,
    required this.screenTitle,
    required this.header,
    this.anonymousLogin = true,
    Key? key,
  }) : super(key: key);

  final String screenTitle;
  final Widget aboutTheApp;
  final Widget header;
  final bool anonymousLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    bool isWideScreen =
        screenSize.width >= screenSize.height && screenSize.width > 800;

    return Container(
      color: Colors.white,
      child: isWideScreen ? _buildWideScreen() : _buildNarrowScreen(),
    );
  }

  //Used when screen width >= screen height
  Widget _buildWideScreen() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: LoginWidget(
              anonymousLogin: anonymousLogin,
            ),
          ),
        ),
        Expanded(child: aboutTheApp)
      ],
    );
  }

  //Used when screen height > screen width
  Widget _buildNarrowScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              header,
              LoginWidget(
                anonymousLogin: anonymousLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
