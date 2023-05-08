import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// CopyToClipboardWidget is a widget that copies the text to the clipboard
/// when tapped.
///
class CopyToClipboardWidget extends StatelessWidget {
  final String? text;
  final String Function()? getText;
  final bool enabled;
  final Widget child;

  CopyToClipboardWidget(
      {Key? key,
      this.text,
      this.getText,
      required this.child,
      this.enabled = true})
      : super(key: key) {
    assert(this.text != null || this.getText != null,
        'text or getText must be provided');
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (!enabled) return;
          //copy to clipboard
          final txt = this.text ?? getText!();
          Clipboard.setData(ClipboardData(text: txt));
          //toast copied to clipboard
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Copied to clipboard: ' + stringLeft(txt ?? '', 30))));
        },
        child: child,
      );
}

// ///
// /// CopyToClipboardWidget is a widget that copies the text to the clipboard
// /// when tapped.
// ///
// class CopyToClipboard2 extends StatelessWidget {
//   // final String? text;
//   final Function(String text) onTap;
//   final bool enabled;
//   final Widget child;

//   const CopyToClipboard2(
//       {Key? key, required this.text, required this.child, this.enabled = true})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: () {
//           if (!enabled) return;
//           //copy to clipboard
//           Clipboard.setData(ClipboardData(text: ));
//           //toast copied to clipboard
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content:
//                   Text('Copied to clipboard: ' + stringLeft(text ?? '', 30))));
//         },
//         child: child,
//       );
// }
