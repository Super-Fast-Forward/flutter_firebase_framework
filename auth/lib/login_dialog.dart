import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginDialog extends ConsumerWidget {
  const LoginDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AlertDialog(
      title: Text("Please log in"),
      content: SizedBox(
        height: 200.0, // Change as per your requirement
        width: 400.0, // Change as per your requirement
      ),
    );
  }
}
