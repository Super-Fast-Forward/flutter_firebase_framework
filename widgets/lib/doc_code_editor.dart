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
import 'package:providers/generic.dart';
import 'package:widgets/copy_to_clipboard_widget.dart';

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
  final int saveDelay;
  final bool debugPrint;

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
      this.saveDelay = 1000,
      this.debugPrint = false,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DocCodeEditorState();
}

class DocCodeEditorState extends ConsumerState<DocCodeEditor> {
  Timer? descSaveTimer;
  StreamSubscription? sub;
  final SNP status = snp<String>('saved');

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
    return Stack(children: [
      CodeTheme(
          data: CodeThemeData(styles: monokaiSublimeTheme),
          child: CodeField(
              expands: true,
              enabled: widget.enabled,
              wrap: true,
              controller: _controller,
              onChanged: (value) {
                //widget.docRef.update({'code': value});
                ref.read(status.notifier).value = 'changed';
                if (descSaveTimer != null && descSaveTimer!.isActive) {
                  descSaveTimer!.cancel();
                }
                descSaveTimer = Timer(Duration(milliseconds: widget.saveDelay),
                    () => saveValue(value));
                //if (widget.onChanged != null) widget.onChanged!(v);
              })),
      Positioned(
          right: 0,
          top: 0,
          child: Icon(
            ref.watch(status) == 'saved'
                ? Icons.check_circle
                : (ref.watch(status) == 'saving'
                    ? Icons.save
                    : (ref.watch(status) == 'error'
                        ? Icons.error
                        : Icons.edit)),
            color: Colors.green,
            size: 10,
          )),
      Positioned(
          right: 0,
          top: 0,
          child: CopyToClipboardWidget(
              text: _controller.text, child: Icon(Icons.copy)))
    ]);
  }

  void saveValue(String s) async {
    ref.read(status.notifier).value = 'saving';
    if (widget.debugPrint) {
      print('status: ${ref.read(status.notifier).value}');
    }
    try {
      await widget.docRef.set({widget.field: s}, SetOptions(merge: true));
    } catch (e) {
      if (widget.debugPrint) {
        print('error saving: ${e.toString()}');
      }
      ref.read(status.notifier).value = 'error';
    }

    ref.read(status.notifier).value = 'saved';
    if (widget.debugPrint) {
      print('status: ${ref.read(status.notifier).value}');
    }
  }
}
