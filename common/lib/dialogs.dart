import 'package:flutter/material.dart';

showCustomDialog(BuildContext context, String title, Widget content,
        List<Widget> actions) =>
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(title), content: content, actions: actions));

showConfirmDialog(
  BuildContext context,
  String title,
  Widget content,
  Function action, {
  confirmText = 'OK',
  cancelText = 'Cancel',
}) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: content,
            actions: [
              TextButton(
                  onPressed: () {
                    action();
                    Navigator.of(context).pop(false);
                  },
                  child: Text(confirmText)),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(cancelText)),
            ],
          ));
}
