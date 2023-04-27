import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';

import 'col_stream_builder.dart';

class DocFieldDropDown extends ConsumerWidget {
  final DocumentReference docRef;
  final String field;

  final Function(String?)? onChanged;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>? valueNP;
  final List<String> items;

  const DocFieldDropDown(this.docRef, this.field, this.valueNP, this.items,
      {this.onChanged, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP(docRef.path)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (doc) => DropdownButton<String>(
                value: doc.data()![field],
                onChanged: (String? newValue) {
                  docRef.update({field: newValue});

                  if (valueNP != null)
                    ref.read(valueNP!.notifier).value = newValue;

                  if (onChanged != null) onChanged!(newValue);
                },
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ));
}

class DocFieldDropDown2 extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final bool enabled;

  final Function(String?)? onChanged;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>? valueNP;
  final List<String> items;

  const DocFieldDropDown2(this.docRef, this.field, this.items,
      {this.valueNP, this.onChanged, this.enabled = false, super.key});

  @override
  ConsumerState<DocFieldDropDown2> createState() => DocDropDown2State();
}

class DocDropDown2State extends ConsumerState<DocFieldDropDown2> {
  StreamSubscription? sub;
  final TextEditingController ctrl = TextEditingController();
  String? val;

  @override
  void initState() {
    super.initState();
    sub = widget.docRef
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> event) {
      if (!event.exists) return;
      val = event.data()![widget.field] as String?;

      if (widget.valueNP != null)
        ref.read(widget.valueNP!.notifier).value = val;
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
    return DropdownButton<String>(
      value: val,
      onChanged: !widget.enabled
          ? null
          : (String? newValue) {
              widget.docRef.update({widget.field: newValue});

              if (widget.valueNP != null)
                ref.read(widget.valueNP!.notifier).value = val;

              if (widget.onChanged != null) widget.onChanged!(newValue);
            },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

///
/// DocFieldDropDown3 - a dropdown that is populated from a collection stream
/// - docRef - the document reference
/// - field - the field to update
/// - colStreamProvider - the collection stream provider
/// - builder - the builder function to create the dropdown items
/// - valueNP - the value notifier provider to update
/// - onChanged - the function to call when the value changes
/// - enabled - whether the dropdown is enabled
///
class DocFieldDropDown3 extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final bool enabled;

  final Function(String?)? onChanged;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>? valueNP;
  final List<DropdownMenuItem<dynamic>> items;

  const DocFieldDropDown3(this.docRef, this.field, this.items,
      {this.valueNP, this.onChanged, this.enabled = false, super.key});

  @override
  ConsumerState<DocFieldDropDown3> createState() => DocDropDown3State();
}

class DocDropDown3State extends ConsumerState<DocFieldDropDown3> {
  StreamSubscription? sub;
  final TextEditingController ctrl = TextEditingController();
  String? val;

  @override
  void initState() {
    super.initState();
    sub = widget.docRef
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> event) {
      print('DocDropDown3State.initState with ${event.data()}');
      if (!event.exists) return;
      setState(() {
        val = event.data()![widget.field] as String?;
      });

      if (widget.valueNP != null)
        ref.read(widget.valueNP!.notifier).value = val;
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
    print('DocDropDown3State.build with ${val}');
    return DropdownButton<dynamic>(
      value: val,
      onChanged: !widget.enabled
          ? null
          : (dynamic newValue) {
              val = newValue;
              widget.docRef.update({widget.field: newValue});

              if (widget.valueNP != null)
                ref.read(widget.valueNP!.notifier).value = val;

              if (widget.onChanged != null) widget.onChanged!(newValue);
            },
      items: widget.items,
    );
  }
}

///
/// DocFieldColStreamDropDown - a dropdown that is populated from a collection stream
/// - docRef - the document reference
/// - field - the field to update
/// - colStreamProvider - the collection stream provider
/// - builder - the builder function to create the dropdown items
/// - valueNP - the value notifier provider to update
/// - onChanged - the function to call when the value changes
/// - enabled - is the dropdown enabled
///
class DocFieldColStreamDropDown extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final AutoDisposeStreamProvider<QS> colStreamProvider;
  final List<DropdownMenuItem> Function(BuildContext context, QS col) builder;

  final bool enabled;
  final Function(String?)? onChanged;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>? valueNP;

  const DocFieldColStreamDropDown(
      this.docRef, this.field, this.colStreamProvider, this.builder,
      {this.valueNP, this.onChanged, this.enabled = false, super.key});

  @override
  ConsumerState<DocFieldColStreamDropDown> createState() =>
      DocFieldColStreamDropDownState();
}

class DocFieldColStreamDropDownState
    extends ConsumerState<DocFieldColStreamDropDown> {
  StreamSubscription? sub;
  final TextEditingController ctrl = TextEditingController();
  String? val;

  @override
  void initState() {
    super.initState();
    sub = widget.docRef
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> event) {
      if (!event.exists) return;
      val = event.data()![widget.field] as String?;

      if (widget.valueNP != null)
        ref.read(widget.valueNP!.notifier).value = val;
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
  Widget build(BuildContext context) => ColStreamBuilder(
        widget.colStreamProvider,
        (context, docs) => DropdownButton<dynamic>(
            value: val,
            onChanged: !widget.enabled
                ? null
                : (dynamic newValue) {
                    widget.docRef.update({widget.field: newValue});

                    if (widget.valueNP != null)
                      ref.read(widget.valueNP!.notifier).value = val;

                    if (widget.onChanged != null) widget.onChanged!(newValue);
                  },
            items: widget.builder(context, docs)),
      );
}
