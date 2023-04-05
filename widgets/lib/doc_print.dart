import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';

import 'doc_stream_widget.dart';

class DocPrintWidget extends ConsumerWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;

  DocPrintWidget(this.docRef, this.field, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DocStreamWidget(
        docSP(docRef.path), (context, doc) => Text(formatFirestoreDoc(doc)));
  }
}
