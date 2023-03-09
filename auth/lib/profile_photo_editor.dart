// import 'dart:html' as html;
// import 'dart:html';
// import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'file_upload_notifier.dart';

// const double PHOTO_RADIUS = 50;
// //const double PROFILE_PHOTO_WIDTH = 50;
// //const PERSON_URL = 'images/company.png';

// class ProfilePhotoEditor extends ConsumerWidget {
//   final String bucketPath;
//   ProfilePhotoEditor(this.bucketPath);

//   // final TextEditingController _name = TextEditingController();
//   // final FocusNode _nameFocus = FocusNode();

//   final profilePhotoUploadStateProvider =
//       StateNotifierProvider((ref) => FileUploadNotifier());

//   @override
//   Widget build(BuildContext context, WidgetRef ref) => Column(children: [
//         Flexible(
//             child: GestureDetector(
//                 //child: Container(),
//                 child: (ref.watch(profilePhotoUploadStateProvider) == null ||
//                         ref.watch(profilePhotoUploadStateProvider) ==
//                             TaskState.success)
//                     ? buildPhoto(context, ref)
//                     : (ref.watch(profilePhotoUploadStateProvider) ==
//                             TaskState.running
//                         ? Center(child: CircularProgressIndicator())
//                         : Container()),
//                 onTap: () async {
//                   html.InputElement uploadInput =
//                       html.FileUploadInputElement() as InputElement;

//                   uploadInput.onChange.listen((e) async {
//                     // read file content as dataURL
//                     final files = uploadInput.files!;
//                     if (files.length == 1) {
//                       final file = files[0];
//                       html.FileReader reader = html.FileReader();

//                       reader.onLoadEnd.listen((e) async {
//                         // print("wrote bytes");

//                         UploadTask _uploadTask;
//                         _uploadTask = FirebaseStorage.instance
//                             .ref()
//                             .child(bucketPath +
//                                 FirebaseAuth.instance.currentUser!.uid +
//                                 '.jpeg')
//                             .putData(
//                                 reader.result as Uint8List,
//                                 SettableMetadata(
//                                   cacheControl: 'public,max-age=31536000',
//                                   contentType: 'image/jpeg',
//                                 ));

//                         _uploadTask.catchError((error) {
//                           print('photo storage error');
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text(error.toString())));
//                         });

//                         // print('set upload task notifier');
//                         ref
//                             .read(profilePhotoUploadStateProvider.notifier)
//                             .uploadTask = _uploadTask;

//                         final TaskSnapshot downloadUrl = (await _uploadTask);

//                         final String url =
//                             (await downloadUrl.ref.getDownloadURL());

//                         await FirebaseStorage.instance
//                             .ref()
//                             .child(bucketPath +
//                                 FirebaseAuth.instance.currentUser!.uid +
//                                 '.jpeg')
//                             .updateMetadata(SettableMetadata(
//                                 cacheControl: 'public,max-age=31536000',
//                                 contentType: 'image/jpeg',
//                                 customMetadata: {}));

//                         FirebaseFirestore.instance
//                             .doc(
//                                 'userInfo/${FirebaseAuth.instance.currentUser!.uid}')
//                             .update({"photoUrl": url});
//                       });

//                       reader.onError.listen((Object error) {
//                         print('photo read error: ${error.toString()}');
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(error.toString())));
//                       });

//                       reader.readAsArrayBuffer(file);
//                     }
//                   });
//                   uploadInput.click();
//                 }))
//       ]);

//   Widget buildPhoto(BuildContext context, WidgetRef ref) => Center(
//       child: ref
//           .watch(docSP('userInfo/${FirebaseAuth.instance.currentUser!.uid}'))
//           .when(
//             loading: () => Container(),
//             error: (e, s) => ErrorWidget(e),
//             data: (userInfo) => CircleAvatar(
//                 radius: 50,
//                 backgroundImage: userInfo.exists &&
//                         !(userInfo.data()?['photoUrl'] ?? '').isEmpty
//                     ? Image.network(userInfo.data()!['photoUrl'],
//                             width: 50, height: 50)
//                         .image
//                     : (FirebaseAuth.instance.currentUser?.photoURL == null
//                         ? Image.asset(PERSON_IMG).image
//                         : Image.network(
//                                 FirebaseAuth.instance.currentUser!.photoURL!)
//                             .image)),
//           ));
// }
