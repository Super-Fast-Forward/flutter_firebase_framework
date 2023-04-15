import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';

/// A widget that displays a text field from a document.
///
/// It is a wrapper around the Text widget. It is using the StreamProvider to listen
/// to changes in the document.
///
/// Example:
///
/// DocFieldText(FirebaseFirestore.instance.collection('users').doc('123'), 'name')
///
/// This will show the value of the field 'name' from the document '123' in the collection 'users'.
///
///
class DocFieldText extends ConsumerWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final int maxLines;
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
  final Function(BuildContext, WidgetRef, String)? builder;

  DocFieldText(this.docRef, this.field,
      {Key? key,
      this.style,
      this.maxLines = 1,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.clip,
      this.softWrap = true,
      this.textDirection,
      this.locale,
      this.strutStyle,
      this.textWidthBasis = TextWidthBasis.parent,
      this.textHeightBehavior,
      this.excludeFromSemantics,
      this.builder = null})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(docRef.path)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (doc) => Text(
            builder == null
                ? (doc.data()?[field].toString() ?? '')
                : builder!(context, ref, doc.data()?[field]),
            maxLines: maxLines,
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
