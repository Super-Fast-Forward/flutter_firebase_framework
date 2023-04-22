import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:providers/generic.dart';

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

class DocFieldDropDown3 extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final bool enabled;

  final Function(String?)? onChanged;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?>? valueNP;
  final List<DropdownMenuItem<dynamic>> items;
  final List<String> values;

  const DocFieldDropDown3(this.docRef, this.field, this.values, this.items,
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
    return DropdownButton<dynamic>(
      value: val,
      onChanged: !widget.enabled
          ? null
          : (dynamic newValue) {
              widget.docRef.update({widget.field: newValue});

              if (widget.valueNP != null)
                ref.read(widget.valueNP!.notifier).value = val;

              if (widget.onChanged != null) widget.onChanged!(newValue);
            },
      items: widget.items,
    );
  }
}
