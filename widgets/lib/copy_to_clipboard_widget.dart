import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboardWidget extends StatelessWidget {
  final String text;
  final Widget child;

  const CopyToClipboardWidget(
      {Key? key, required this.text, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //copy to clipboard
        Clipboard.setData(ClipboardData(text: text));
        //toast copied to clipboard
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Copied to clipboard: ' + text)));
      },
      child: child,
    );
  }
}
// GestureDetector(
//                 onTap: () {
//                   //copy to clipboard
//                   Clipboard.setData(ClipboardData(
//                       text:
//                           //jsonEncode(runDoc.data()!.map((k, v) => MapEntry(k, v.toString()))
//                           formatFirestoreDoc(runDoc)));
//                   //toast copied to clipboard
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text('Copied to clipboard: ' +
//                           formatFirestoreDoc(runDoc))));
//                 },
//                 child: Text(formatFirestoreDoc(runDoc)));
//           },
//           loading: () => Container(),
//           error: (e, s) => Text(e.toString()),
//         );