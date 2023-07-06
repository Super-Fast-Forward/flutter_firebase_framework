import 'dart:core';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:widgets/copy_to_clipboard_widget.dart';
import 'package:widgets/doc_stream_widget.dart';

class MessageWidget extends ConsumerWidget {
  final DR messageDocRef;
  final Function(String code)? useCode;
  final Widget? extension;

  MessageWidget(this.messageDocRef, this.useCode, {this.extension, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => DocStreamWidget(
      key: ValueKey(messageDocRef.id),
      docSP(messageDocRef.path),
      (context, messageDoc) => ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 800),
          child: Card(
              child: ListTile(
                  trailing: IconButton(
                      onPressed: () => messageDocRef.delete(),
                      icon: Icon(Icons.delete)),
                  leading: Column(
                    children: [
                      // Text(
                      //     formatDateTime(messageDoc.data()?['timeCreated']),
                      //     style: Theme.of(context).textTheme.labelSmall),
                      Text(messageDoc.data()?['role'] ?? ''),
                      CopyToClipboardWidget(
                          text: messageDoc.data()?['content'] ?? '',
                          child: Icon(Icons.copy))
                    ],
                  ),
                  title: ConstrainedBox(
                    constraints: BoxConstraints(
                        // maxHeight: 200
                        ),
                    child: SingleChildScrollView(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child:
                                    Text(messageDoc.data()?['content'] ?? '')),
                            Flexible(
                                child: Column(
                              children: [
                                Text(messageDoc.data()?['error'] ?? '',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ))
                          ],
                        )),
                        if (extension != null) Flexible(child: extension!)
                      ],
                    )),
                  )))));
}
