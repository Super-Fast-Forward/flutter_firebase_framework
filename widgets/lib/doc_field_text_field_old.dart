// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// /// A text field that updates a document field in Firestore
// /// when the text changes.
// /// The text field is initialized with the value of the document field.
// /// The text field is updated when the document field changes.
// /// The document field is updated when the text field changes.
// /// The document field is updated after a 2 second delay.
// /// The document field is updated with merge: true.
// ///
// /// Example:
// ///
// /// DocFieldTextField(docRef, 'description', 5,
// ///  decoration: InputDecoration(
// ///   labelText: 'Description',
// ///  border: OutlineInputBorder(),
// /// ),
// ///
// class DocFieldTextField extends ConsumerStatefulWidget {
//   final DocumentReference<Map<String, dynamic>> docRef;
//   final String field;
//   final InputDecoration? decoration;
//   final int maxLines;
//   final TextStyle? style;
//   final TextAlign textAlign;
//   final TextDirection? textDirection;
//   final StrutStyle? strutStyle;
//   final bool enabled;
//   final bool canAddLines;

//   DocFieldTextField(this.docRef, this.field, this.maxLines,
//       {this.decoration,
//       this.style,
//       this.textAlign = TextAlign.start,
//       this.textDirection,
//       this.strutStyle,
//       this.enabled = true,
//       this.canAddLines = false,
//       Key? key})
//       : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       DocMultilineTextFieldState();
// }

// class DocMultilineTextFieldState extends ConsumerState<DocFieldTextField> {
//   Timer? descSaveTimer;
//   StreamSubscription? sub;
//   int minLines = 1;
//   final TextEditingController ctrl = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     sub = widget.docRef.snapshots().listen((event) {
//       if (!event.exists) return;
//       print('received ${event.data()![widget.field]}');
//       if (ctrl.text != event.data()![widget.field]) {
//         ctrl.text = event.data()![widget.field];
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (sub != null) {
//       sub!.cancel();
//       sub = null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       maxLines: widget.maxLines,
//       minLines: minLines,
//       decoration: widget.decoration,
//       style: widget.style,
//       textAlign: widget.textAlign,
//       textDirection: widget.textDirection,
//       strutStyle: widget.strutStyle,
//       controller: ctrl,
//       enabled: widget.enabled,
//       onChanged: (v) {
//         if (descSaveTimer != null && descSaveTimer!.isActive) {
//           descSaveTimer!.cancel();
//         }
//         descSaveTimer = Timer(Duration(milliseconds: 2000), () {
//           Map<String, dynamic> map = {};
//           map[widget.field] = v;
//           widget.docRef.set(map, SetOptions(merge: true));
//         });

//         setState(() {
//           minLines = !widget.canAddLines
//               ? this.minLines
//               : (v.split('\n').length + 1 > widget.maxLines
//                   ? widget.maxLines
//                   : v.split('\n').length + 1);
//         });
//       },
//     );
//   }
// }
