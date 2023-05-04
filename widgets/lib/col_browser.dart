import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';
import 'package:widgets/col_stream_widget.dart';

class ColBrowser extends ConsumerWidget {
  final AutoDisposeStreamProvider<QS> colStreamProvider;
  final Widget Function(
      BuildContext context, Widget listWidget, Widget itemDetails) builder;
  final Widget Function(BuildContext context, DS doc) listItemBuilder;
  final Widget Function(BuildContext context, DR doc) itemDetailsBuilder;
  final bool debugPrint;

  ColBrowser(
    this.colStreamProvider,
    this.builder,
    this.listItemBuilder,
    this.itemDetailsBuilder, {
    this.debugPrint = false,
    super.key,
  });

  SNP<String?> activeItem = snp(null);

  @override
  Widget build(BuildContext context, WidgetRef ref) => builder(
      context,
      ColStreamWidget<Widget>(
          colStreamProvider,
          (context, col, items) => Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: items),
          (context, doc) => GestureDetector(
              onTap: () {
                if (debugPrint) print('doc.id: ${doc.id}');
                ref.read(activeItem.notifier).value = doc.reference.path;
              },
              child: listItemBuilder(context, doc))),
      ref.watch(activeItem) == null
          ? Text('no item selected')
          : itemDetailsBuilder(context, kDB.doc(ref.watch(activeItem)!)));
}
