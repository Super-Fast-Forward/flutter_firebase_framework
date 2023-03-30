import 'package:common/common.dart';
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
  final Widget Function(BuildContext context, QS col, List items) builder;
  final Widget Function(BuildContext context, DS doc) itemBuilder;
  final AutoDisposeStreamProvider<QS> colStreamProvider;
  const ColStreamWidget({
    super.key,
    required this.colStreamProvider,
    required this.builder,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(colStreamProvider).when(
          data: (col) {
            return builder(context, col,
                col.docs.map((doc) => itemBuilder(context, doc)).toList());
          },
          loading: () => Text('loading'),
          error: (e, s) => ErrorWidget(e));
}
