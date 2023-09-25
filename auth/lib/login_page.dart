import 'package:auth/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reusable login page UI
class LoginPage extends ConsumerWidget {
  const LoginPage({
    super.key,
    this.termsAndConditionsPageUrl,
    required this.aboutTheApp,
    required this.screenTitle,
    required this.header,
    this.anonymousLogin = false,
    this.githubLogin = true,
    this.googleLogin = true,
    this.linkedInLogin = false,
  });

  final bool anonymousLogin;
  final bool linkedInLogin;
  final bool googleLogin;
  final bool githubLogin;

  final String screenTitle;
  final Widget aboutTheApp;
  final Widget header;
  final String? termsAndConditionsPageUrl;

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
            child: LogInWidget(
              anonymousLogin: anonymousLogin,
              githubLogin: githubLogin,
              googleLogin: googleLogin,
              linkedInLogin: linkedInLogin,
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
              LogInWidget(
                anonymousLogin: anonymousLogin,
                githubLogin: githubLogin,
                googleLogin: googleLogin,
                linkedInLogin: linkedInLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
