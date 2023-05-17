import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'doc_field_text_field_old.dart';

///
/// This is a widget that allows you to edit a field in a document.
/// It is a wrapper around a [TextField] that automatically saves the
/// value to the document.
/// It is using the [StreamProvider] to listen to changes in the document.
/// It is using a [Timer] to delay the save operation.
/// This is to prevent the save operation from being called on every keystroke.
///
/// Example:
///
/// DocFieldTextField(FirebaseFirestore.instance.collection('users').doc('123'), 'name')
///
/// This will show the value of the field 'name' from the document '123' in the collection 'users'.
///
class DocFieldTextField extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final InputDecoration? decoration;
  final int minLines;
  final int maxLines;
  final bool debugPrint;
  final bool showSaveStatus;
  final int saveDelay;
  final bool enabled;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool canAddLines;
  final TextStyle? style;

  const DocFieldTextField(this.docRef, this.field,
      {this.decoration,
      this.minLines = 1,
      this.maxLines = 1,
      this.keyboardType,
      this.saveDelay = 1000,
      this.showSaveStatus = true,
      this.debugPrint = false,
      this.enabled = true,
      this.onChanged = null,
      this.canAddLines = false,
      this.style,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      DocFieldTextEditState();
}

class DocFieldTextEditState extends ConsumerState<DocFieldTextField> {
  Timer? descSaveTimer;
  StreamSubscription? sub;
  final TextEditingController ctrl = TextEditingController();
  final SNP status = snp<String>('saved!');
  int currentLinesCount = 1;

  @override
  void initState() {
    super.initState();
    currentLinesCount = widget.minLines;
    sub = widget.docRef.snapshots().listen((event) {
      if (!event.exists) return;
      if (widget.debugPrint) {
        print(
            'DocFieldTextEditState ${widget.field} received ${event.data()![widget.field]}');
      }
      if (ctrl.text != event.data()![widget.field]) {
        ctrl.text = event.data()![widget.field];
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (descSaveTimer != null && descSaveTimer!.isActive) {
      descSaveTimer!.cancel();
    }
    if (sub != null) {
      if (widget.debugPrint) {
        print('DocFieldTextEditState sub cancelled');
      }
      sub!.cancel();
      sub = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
            decoration: widget.decoration,
            controller: ctrl,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            style: widget.style,
            minLines: currentLinesCount,
            maxLines: widget.maxLines,
            onChanged: (v) {
              ref.read(status.notifier).value = 'changed';
              if (descSaveTimer != null && descSaveTimer!.isActive) {
                descSaveTimer!.cancel();
              }
              descSaveTimer = Timer(
                  Duration(milliseconds: widget.saveDelay), () => saveValue(v));
              if (widget.onChanged != null) widget.onChanged!(v);

              // setState(() {
              //   currentLinesCount = !widget.canAddLines
              //       ? this.currentLinesCount
              //       : (v.split('\n').length + 1 > widget.maxLines
              //           ? widget.maxLines
              //           : v.split('\n').length + 1);
              // });
              setState(() {
                final textLinesCount = v.split('\n').length + 1;
                if (textLinesCount < widget.minLines) {
                  currentLinesCount = widget.minLines;
                } else if (textLinesCount > widget.maxLines) {
                  currentLinesCount = widget.maxLines;
                } else {
                  currentLinesCount = textLinesCount;
                }

                // currentLinesCount = !widget.canAddLines
                //     ? currentLinesCount
                //     : textLinesCount > widget.maxLines
                //         ? widget.maxLines
                //         : textLinesCount < widget.minLines
                //             ? widget.minLines
                //             : textLinesCount;
              });
            },
            onSubmitted: (v) {
              if (descSaveTimer != null && descSaveTimer!.isActive) {
                descSaveTimer!.cancel();
              }
              saveValue(v);
            }),
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
            ))
      ],
    );
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

// class DocFieldTextField extends ConsumerStatefulWidget {
//   final DocumentReference docRef;
//   final String field;
//   final InputDecoration? decoration;

//   final TextEditingController ctrl = TextEditingController();

//   DocFieldTextField(this.docRef, this.field, {this.decoration, Key? key})
//       : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       DocFieldTextEditState();
// }

// class DocFieldTextEditState extends ConsumerState<DocFieldTextField> {
//   Timer? descSaveTimer;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ref
//         .watch(docSPdistinct(DocParam(widget.docRef.path, (prev, curr) {
//           print('equals called');
//           if (prev.data()![widget.field] == curr.data()![widget.field]) {
//             print('field ${widget.field} did not change, return true');
//             return true;
//           }
//           if (widget.ctrl.text == curr.data()![widget.field]) {
//             print(
//                 'controller: ${widget.ctrl.text}, doc field: ${curr.data()![widget.field]}');
//             return true;
//           }
//           print(
//               'field changed! ctrl: ${widget.ctrl.text}!=${curr.data()![widget.field]}');
//           return false;
//         })))
//         .when(
//             loading: () => Container(),
//             error: (e, s) => ErrorWidget(e),
//             data: (docSnapshot) {
//               return TextField(
//                 // autovalidateMode: AutovalidateMode.always,
//                 //autoalidate: true,
//                 // validator: (v) {
//                 //   print(v);
//                 //   if (v != null && v.contains('\n')) {
//                 //     print('submitted; ${v}');
//                 //     if (descSaveTimer != null && descSaveTimer!.isActive) {
//                 //       descSaveTimer!.cancel();
//                 //     }
//                 //     descSaveTimer = Timer(Duration(milliseconds: 200), () {
//                 //       if (docSnapshot.data() == null ||
//                 //           v != docSnapshot.data()![widget.field]) {
//                 //         Map<String, dynamic> map = {};
//                 //         map[widget.field] = v;
//                 //         // the document will get created, if not exists
//                 //         widget.docRef.set(map, SetOptions(merge: true));
//                 //         // throws exception if document doesn't exist
//                 //         //widget.docRef.update({widget.field: v});
//                 //       }
//                 //     });
//                 //   }
//                 // },

//                 decoration: widget.decoration,
//                 controller: widget.ctrl
//                   ..text = docSnapshot.data()![widget.field] ?? '',
//                 onSubmitted: (v) {
//                   if (descSaveTimer != null && descSaveTimer!.isActive) {
//                     descSaveTimer!.cancel();
//                   }
//                   descSaveTimer = Timer(Duration(milliseconds: 200), () {
//                     if (docSnapshot.data() == null ||
//                         v != docSnapshot.data()![widget.field]) {
//                       Map<String, dynamic> map = {};
//                       map[widget.field] = v;
//                       // the document will get created, if not exists
//                       widget.docRef.set(map, SetOptions(merge: true));

//                       print(v);
//                       // throws exception if document doesn't exist
//                       //widget.docRef.update({widget.field: v});
//                     }
//                   });
//                 },
//                 // onChanged: (v) {
//                 //   if (descSaveTimer != null && descSaveTimer!.isActive) {
//                 //     descSaveTimer!.cancel();
//                 //   }
//                 //   descSaveTimer = Timer(Duration(milliseconds: 200), () {
//                 //     if (docSnapshot.data() == null ||
//                 //         v != docSnapshot.data()![widget.field]) {
//                 //       Map<String, dynamic> map = {};
//                 //       map[widget.field] = v;
//                 //       // the document will get created, if not exists
//                 //       widget.docRef.set(map, SetOptions(merge: true));
//                 //       // throws exception if document doesn't exist
//                 //       //widget.docRef.update({widget.field: v});
//                 //     }
//                 //   });
//                 // },
//               );
//             });
//   }
// }

// ///
// /// Version of textedit without delayed saving
// ///
// // class DocFieldTextField extends ConsumerWidget {
// //   final DocumentReference docRef;
// //   final String field;
// //   final TextEditingController ctrl = TextEditingController();

// //   DocFieldTextField(this.docRef, this.field);

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     // print('DocFieldTextField rebuild');
// //     return ref
// //         .watch(docSPdistinct(DocParam(docRef.path, (prev, curr) {
// //           // print('equals called');
// //           if (prev.data()![field] == curr.data()![field]) {
// //             // print('field ${field} did not change, return true');
// //             return true;
// //           }
// //           if (ctrl.text == curr.data()![field]) {
// //             // print(
// //             //     'ctrl.text (${ctrl.text}) == snap text (${curr.data()![field]})');
// //             return true;
// //           }
// //           return false;
// //         })))
// //         .when(
// //             loading: () => Container(),
// //             error: (e, s) => ErrorWidget(e),
// //             data: (docSnapshot) => TextField(
// //                   controller: ctrl..text = docSnapshot.data()![field],
// //                   onChanged: (v) {
// //                     docRef.update({field: v});
// //                   },
// //                 ));
// //   }
// // }



// ///
// /// This is a widget that allows you to edit a field in a document.
// /// It is a wrapper around a [TextField] that automatically saves the
// /// value to the document.
// /// It is using the [StreamProvider] to listen to changes in the document.
// /// It is using a [Timer] to delay the save operation.
// /// This is to prevent the save operation from being called on every keystroke.
// ///
// /// Example:
// ///
// /// DocFieldTextField(FirebaseFirestore.instance.collection('users').doc('123'), 'name')
// ///
// /// This will show the value of the field 'name' from the document '123' in the collection 'users'.
// ///
// class DocFieldTextField extends ConsumerStatefulWidget {
//   final DocumentReference<Map<String, dynamic>> docRef;
//   final String field;
//   final InputDecoration? decoration;
//   final bool debugPrint;
//   final bool showSaveStatus;

//   DocFieldTextField(this.docRef, this.field,
//       {this.decoration,
//       this.showSaveStatus = true,
//       this.debugPrint = false,
//       Key? key})
//       : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       DocFieldTextEditState();
// }

// class DocFieldTextEditState extends ConsumerState<DocFieldTextField> {
//   Timer? descSaveTimer;
//   StreamSubscription? sub;
//   final TextEditingController ctrl = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     sub = widget.docRef.snapshots().listen((event) {
//       if (!event.exists) return;
//       if (widget.debugPrint)
//         print(
//             'DocFieldTextEditState2 ${widget.field} received ${event.data()![widget.field]}');
//       if (ctrl.text != event.data()![widget.field]) {
//         ctrl.text = event.data()![widget.field];
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (sub != null) {
//       print('sub cancelled');
//       sub!.cancel();
//       sub = null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: widget.decoration,
//       controller: ctrl,
//       onChanged: (v) => saveValue(v),
//       onSubmitted: (v) => saveValue(v),
//     );
//   }

//   void saveValue(String v) {
//     if (descSaveTimer != null && descSaveTimer!.isActive) {
//       descSaveTimer!.cancel();
//     }
//     descSaveTimer = Timer(Duration(milliseconds: 200), () {
//       Map<String, dynamic> map = {};
//       map[widget.field] = v;
//       widget.docRef.set(map, SetOptions(merge: true));
//     });
//   }
// }
