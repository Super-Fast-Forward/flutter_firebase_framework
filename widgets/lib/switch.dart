import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:widgets/builders.dart';

class SwitchWidget extends ConsumerWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;

  SwitchWidget(
    this.docRef,
    this.field,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DocStreamWidget(
        docStreamProvider: docSP(docRef.path),
        builder: (context, doc) => Switch(
            value: doc.data()![field] as bool,
            onChanged: (v) {
              docRef.update({field: v});
              // ref.read(firestoreProvider).runTransaction((transaction) async {
              //   final freshDoc = await transaction.get(docRef);
              //   transaction.update(docRef, {field: !freshDoc.data()![field]});
              // });
            }));
  }
}
