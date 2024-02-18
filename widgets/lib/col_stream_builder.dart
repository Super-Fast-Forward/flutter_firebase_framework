import 'common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
///   colSP('test_collection'),
///     (context, col, items) => ListView(
///       shrinkWrap: true,
///       children: items,
///     ),
///     (c, e) => Text(e.data()['text']
///    )),
///
class ColStreamBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, QS col) builder;
  final AutoDisposeStreamProvider<QS> colStreamProvider;
  final Widget? loader;

  const ColStreamBuilder(
    this.colStreamProvider,
    this.builder, {
    super.key,
    this.loader,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(colStreamProvider).when(
          data: (col) {
            return builder(context, col);
          },
          loading: () => loader == null ? Container() : loader!,
          error: (e, s) => ErrorWidget(e));
}
