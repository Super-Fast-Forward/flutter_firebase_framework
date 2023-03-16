import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocTextWidget extends ConsumerWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final bool? excludeFromSemantics;

  DocTextWidget(this.docRef, this.field,
      {Key? key,
      this.style,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.clip,
      this.softWrap = true,
      this.textDirection,
      this.locale,
      this.strutStyle,
      this.textWidthBasis = TextWidthBasis.parent,
      this.textHeightBehavior,
      this.excludeFromSemantics})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(StreamProvider<DocumentSnapshot<Map<String, dynamic>>>(
            (ref) => FirebaseFirestore.instance.doc(docRef.path).snapshots()))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (doc) => Text(doc.data()?[field] ?? '',
                style: style,
                textAlign: textAlign,
                overflow: overflow,
                softWrap: softWrap,
                textDirection: textDirection,
                locale: locale,
                strutStyle: strutStyle,
                textWidthBasis: textWidthBasis,
                textHeightBehavior: textHeightBehavior));
  }
}
