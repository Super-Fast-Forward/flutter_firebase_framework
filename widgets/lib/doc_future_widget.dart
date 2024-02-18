import 'common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// A widget that builds itself based on the latest snapshot of interaction
/// with a [Stream].
///
/// [docStreamProvider]: The stream provider to listen to.
/// [builder]: Called every time the [docFutureProvider] emits a new item to build
/// the widget based on the document received from Firestore.
///
/// Example:
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///  return
///   DocStreamWidget(
///    docSP('test_collection/test_doc'),
///   (context, doc) => Text(doc.data()['text'])),
/// );
///
class DocFutureWidget extends ConsumerWidget {
  final Widget Function(BuildContext context, DS doc) builder;
  final AutoDisposeFutureProvider<DS> docFutureProvider;
  final Widget? loader;
  const DocFutureWidget(
    this.docFutureProvider,
    this.builder, {
    super.key,
    this.loader,
  }) : assert(builder != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docFutureProvider).when(
          data: (doc) => builder(context, doc),
          loading: () => loader == null ? Container() : loader!,
          error: (e, s) => ErrorWidget(e));
}
