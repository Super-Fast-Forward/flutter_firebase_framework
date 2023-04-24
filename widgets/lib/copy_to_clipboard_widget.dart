import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// CopyToClipboardWidget is a widget that copies the text to the clipboard
/// when tapped.
///
class CopyToClipboardWidget extends StatelessWidget {
  final String? text;
  final Widget child;

  const CopyToClipboardWidget(
      {Key? key, required this.text, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          //copy to clipboard
          Clipboard.setData(ClipboardData(text: text));
          //toast copied to clipboard
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Copied to clipboard: ' + (text ?? ''))));
        },
        child: child,
      );
}
