import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocStreamWidget extends ConsumerWidget {
  final Widget Function(BuildContext context, DS doc) builder;
  final AutoDisposeStreamProvider<DS> docStreamProvider;
  const DocStreamWidget(
    this.docStreamProvider,
    this.builder, {
    super.key,
  }) : assert(builder != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docStreamProvider).when(
          data: (doc) => builder(context, doc),
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e));
}
