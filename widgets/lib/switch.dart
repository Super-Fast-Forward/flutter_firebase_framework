import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:widgets/builders.dart';

import 'doc_stream_widget.dart';

class SwitchWidget extends ConsumerWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;

  SwitchWidget(this.docRef, this.field, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DocStreamWidget(
        docStreamProvider: docSP(docRef.path),
        builder: (context, doc) => Switch(
            value: doc.data()?[field] ?? false,
            onChanged: (v) {
              docRef.set({field: v}, SetOptions(merge: true));
            }));
  }
}
