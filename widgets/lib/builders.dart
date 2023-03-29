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

/// A widget that builds itself based on the latest snapshot of interaction with
///  a [Stream].
/// [StreamProvider] automatically handles closing the stream when the widget is
/// removed from the widget tree.
/// This widget is useful when you want to build a widget tree based on the
/// latest interaction with a [Stream].
/// See also:
/// * [StreamProvider], which provides a [Stream] and rebuilds dependents
///  when the [Stream] emits an event.
/// * [StreamBuilder], which has a similar API but does not manage the
/// subscription.
///
/// ColStreamWidget(
///            colStreamProvider: userAppCommentFamilyProvider(appId),
///           builder: (context, col, items) => ListView(
///                shrinkWrap: true,
///               children: items,
///            ),
///         itemBuilder: (c, e) => DocStreamWidget(
///              docStreamProvider: docSP(e.reference.path),
///             builder: (c, doc) => Row(
///              children: [
///            Text(doc.data()!['text'] ?? ''),
///          ],
///       ),
///    )),
///
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
