import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class DocCodeEditor extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final TextStyle? textStyle;
  final Map<String, TextStyle> styles;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final StrutStyle? strutStyle;
  final bool enabled;
  final int? minLines;
  final int? maxLines;
  final bool expands;
  final bool wraps;
  final Decoration? decoration;
  final Mode? language;

  DocCodeEditor(this.docRef, this.field, this.styles,
      {this.decoration,
      this.textStyle,
      this.textAlign = TextAlign.start,
      this.textDirection,
      this.strutStyle,
      this.enabled = true,
      this.expands = false,
      this.wraps = false,
      this.minLines,
      this.maxLines,
      this.language,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DocCodeEditorState();
}

class DocCodeEditorState extends ConsumerState<DocCodeEditor> {
  Timer? descSaveTimer;
  StreamSubscription? sub;
  CodeController _controller = CodeController(
    // text: verDoc.data()?['code'] ?? '',
    patternMap: {
      r"\B#[a-zA-Z0-9]+\b": TextStyle(color: Colors.red),
      r"\B@[a-zA-Z0-9]+\b": TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.blue,
      ),
      r"\B![a-zA-Z0-9]+\b":
          TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic),
    },
    stringMap: {
      "bev": TextStyle(color: Colors.indigo),
    },
  );
  // final TextEditingController ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.language = widget.language;

    sub = widget.docRef.snapshots().listen((event) {
      if (!event.exists) return;
      print('received ${event.data()![widget.field]}');
      if (_controller.text != event.data()![widget.field]) {
        _controller.text = event.data()![widget.field];
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (sub != null) {
      sub!.cancel();
      sub = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CodeTheme(
        data: CodeThemeData(styles: monokaiSublimeTheme),
        child: CodeField(
            expands: true,
            wrap: true,
            controller: _controller,
            onChanged: (value) {
              widget.docRef.update({'code': value});
            }));
  }
}
