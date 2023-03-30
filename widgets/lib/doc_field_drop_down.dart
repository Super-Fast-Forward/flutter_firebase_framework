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
      {this.onChanged});

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

class DocDropDown2 extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;

  final Function(String?)? onChanged;
  final StateNotifierProvider<GenericStateNotifier<String?>, String?> valueNP;
  final List<String> items;

  const DocDropDown2(this.docRef, this.field, this.valueNP, this.items,
      {this.onChanged});

  @override
  ConsumerState<DocDropDown2> createState() => DocDropDown2State();
}

class DocDropDown2State extends ConsumerState<DocDropDown2> {
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
      ref.read(widget.valueNP.notifier).value = val;
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
      onChanged: (String? newValue) {
        widget.docRef.update({widget.field: newValue});

        ref.read(widget.valueNP.notifier).value = val;
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
