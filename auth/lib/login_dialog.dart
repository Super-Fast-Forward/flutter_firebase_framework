import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';

class LoginDialog extends ConsumerWidget {
  const LoginDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
        title: Text("Please log in"),
        content: SizedBox(
            height: 200.0, // Change as per your requirement
            width: 400.0, // Change as per your requirement
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginWidget(
                      screenTitle: '',
                      onLoginAnonymousButtonPressed: () =>
                          Navigator.pop(context))
                ])));
  }
}
