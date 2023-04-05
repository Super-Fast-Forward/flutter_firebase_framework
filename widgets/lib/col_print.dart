import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';

import 'col_stream_widget.dart';

class ColPrintWidget extends ConsumerWidget {
  final CollectionReference<Map<String, dynamic>> docRef;

  ColPrintWidget(this.docRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ColStreamWidget<Widget>(
      colSP(docRef.path),
      (context, col, items) => Column(children: items),
      (context, doc) => Text(formatFirestoreDoc(doc)));
}
