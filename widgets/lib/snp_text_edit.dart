import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';

// class SnpTextEdit extends ConsumerWidget {
//   final SNP<String> snp;
//   final InputDecoration? decoration;
//   final bool debugPrint;
//   final bool enabled;
//   final Function(String)? onChanged;

//   SnpTextEdit(this.snp,
//       {Key? key,
//       this.decoration,
//       this.debugPrint = false,
//       this.enabled = true,
//       this.onChanged})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return TextField(
//       decoration: decoration,
//       // controller: ctrl,
//       enabled: enabled,
//       onChanged: (v) {
//         ref.read(snp.notifier).value = v;
//         // ref.read(status.notifier).value = 'changed';
//         // if (descSaveTimer != null && descSaveTimer!.isActive) {
//         //   descSaveTimer!.cancel();
//         // }
//         // descSaveTimer = Timer(
//         //     Duration(milliseconds: widget.saveDelay), () => saveValue(v));
//         // if (widget.onChanged != null) widget.onChanged!(v);
//       },
//       //  onSubmitted: (v) {
//       //   ref.read(snp.notifier).value = v;
//       //   // if (descSaveTimer != null && descSaveTimer!.isActive) {
//       //   //   descSaveTimer!.cancel();
//       //   // }
//       //   // saveValue(v);
//       // }
//     );
//   }
// }

class SnpTextEdit extends ConsumerWidget {
  TextEditingController? _ctrl;
  final SNP dataSNP;
  final InputDecoration? decoration;
  final bool debugPrint;
  final bool showSaveStatus;
  final int saveDelay;
  final bool enabled;
  final Function(String)? onChanged;

  SnpTextEdit(this.dataSNP,
      {TextEditingController? ctrl,
      this.decoration,
      this.saveDelay = 1000,
      this.showSaveStatus = true,
      this.debugPrint = false,
      this.enabled = true,
      this.onChanged = null,
      Key? key})
      : _ctrl = ctrl,
        super(key: key) {
    if (this._ctrl == null) this._ctrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextField(
      decoration: decoration,
      controller: _ctrl,
      enabled: enabled,
      onChanged: (v) {
        // ref.read(status.notifier).value = 'changed';
        // if (descSaveTimer != null && descSaveTimer!.isActive) {
        //   descSaveTimer!.cancel();
        // }
        // descSaveTimer = Timer(
        //     Duration(milliseconds: widget.saveDelay), () => saveValue(v));
        // if (widget.onChanged != null) widget.onChanged!(v);
        saveValue(ref, v);
      },
      onSubmitted: (v) {
        // if (descSaveTimer != null && descSaveTimer!.isActive) {
        //   descSaveTimer!.cancel();
        // }
        saveValue(ref, v);
      });

  void saveValue(WidgetRef ref, String s) async {
    ref.read(dataSNP.notifier).value = s;
  }
}
