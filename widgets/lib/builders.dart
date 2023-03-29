import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';

List<T> buildDocFieldList<T>(
    BuildContext context, WidgetRef ref, String address,
    {required T Function(BuildContext context, MapEntry<String, dynamic> data)
        builder}) {
  return ref.watch(docSP(address)).when(
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

class DocStreamWidget extends ConsumerWidget {
  final Widget Function(BuildContext context, DS doc) builder;
  final AutoDisposeStreamProvider<DS> docStreamProvider;
  const DocStreamWidget({
    super.key,
    required this.docStreamProvider,
    required this.builder,
  }) : assert(builder != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docStreamProvider).when(
          data: (doc) => builder(context, doc),
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e));
}

class ColStreamWidget extends ConsumerWidget {
  final Widget Function(BuildContext context, QS col, List<Widget> items)
      builder;
  final Widget Function(BuildContext context, DS doc) itemBuilder;
  final AutoDisposeStreamProvider<QS> colStreamProvider;
  const ColStreamWidget({
    super.key,
    required this.colStreamProvider,
    required this.builder,
    required this.itemBuilder,
  }) : assert(builder != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(colStreamProvider).when(
          data: (col) {
            return builder(context, col,
                col.docs.map((doc) => itemBuilder(context, doc)).toList());
          },
          loading: () => Text('loading'),
          error: (e, s) => Text('error'));
}
