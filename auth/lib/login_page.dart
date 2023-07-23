import 'package:auth/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reusable login page UI
class LoginPage extends ConsumerWidget {
  const LoginPage({
    required this.aboutTheApp,
    required this.screenTitle,
    required this.header,
    this.googleLogin = true,
    this.linkedinLogin = true,
    this.githubLogin = true,
    this.facebookLogin = true,
    this.twitterLogin = true,
    this.emailLogin = true,
    this.anonymousLogin = true,
    Key? key,
  }) : super(key: key);

  final String screenTitle;
  final Widget aboutTheApp;
  final Widget header;

  final bool googleLogin;
  final bool linkedinLogin;
  final bool githubLogin;
  final bool facebookLogin;
  final bool twitterLogin;
  final bool emailLogin;
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

  //used when screen width >= screen height
  Widget _buildWideScreen() {
    return Row(
      children: [
        const Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: LoginWidget(),
            ),
          ),
        ),
        Expanded(child: aboutTheApp)
      ],
    );
  }

  //used when screen height > screen width
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
              const LoginWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
