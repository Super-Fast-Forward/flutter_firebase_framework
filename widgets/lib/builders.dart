import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';

List<T> buildDocFieldList<T>(BuildContext context, WidgetRef ref, String path,
    {required T Function(BuildContext context, MapEntry<String, dynamic> data)
        builder}) {
  return ref.watch(docSP(path)).when(
      data: (doc) =>
          doc.data()!.entries.map<T>((e) => builder(context, e)).toList(),
      loading: () => [],
      error: (e, s) => []);
}

List<T> buildColItems<T>(
    BuildContext context, WidgetRef ref, AutoDisposeStreamProvider<QS> p,
    {required T Function(BuildContext context, DocumentSnapshot data)
        itemBuilder}) {
  return ref.watch(p).when(
      data: (colSnapshot) =>
          colSnapshot.docs.map<T>((doc) => itemBuilder(context, doc)).toList(),
      loading: () => [],
      error: (e, s) => []);
}

T? buildDocField<T>(
    BuildContext context, WidgetRef ref, String path, String field,
    {required T Function(BuildContext context, MapEntry<String, dynamic> data)
        builder}) {
  return ref.watch(docSP(path)).when(
      data: (doc) => doc.data()?[field] ?? null,
      loading: () => null,
      error: (e, s) => null);
}
