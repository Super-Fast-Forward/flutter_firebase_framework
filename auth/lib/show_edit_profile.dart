import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

void showEditProfileDialog(BuildContext context, WidgetRef ref) {
  Widget buildPhoto(BuildContext context, WidgetRef ref) => Center(
      child: FirebaseAuth.instance.currentUser?.photoURL == null
          ? Icon(Icons.person)
          : CircleAvatar(
              radius: 50,
              backgroundImage:
                  Image.network(FirebaseAuth.instance.currentUser!.photoURL!)
                      .image));

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("User Profile"),
            content: SizedBox(
                height: 200.0, // Change as per your requirement
                width: 400.0, // Change as per your requirement
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: buildPhoto(context, ref)),
                      Text(
                          FirebaseAuth.instance.currentUser!.displayName ?? ''),
                      GestureDetector(
                          onTap: () => Clipboard.setData(ClipboardData(
                              text: FirebaseAuth.instance.currentUser!.uid)),
                          child: Text(FirebaseAuth.instance.currentUser!.uid))
                      // ...ref
                      //     .watch(docSP(
                      //         'userInfo/${FirebaseAuth.instance.currentUser?.uid}'))
                      //     .when(
                      //         data: (userDoc) => [
                      //               Text(userDoc.data()!['email']),
                      //               FFLTTextEdit(userDoc, 'name', 'user name',
                      //                   'edit user name',
                      //                   key: Key(userDoc.id)),
                      //             ],
                      //         loading: () => [Loader()],
                      //         error: (e, s) => [ErrorWidget(e)])
                    ])),
            actions: <Widget>[
              ElevatedButton(
                  key: Key('sign_out_btn'),
                  child: Text("Sign Out"),
                  onPressed: () {
                    //Navigator.of(context).popUntil(ModalRoute.withName('/'));
                    // Navigator.of(context).pushNamed(LoginPage.route);
                    Navigator.of(context).pop();
                    FirebaseAuth.instance.signOut();
                  }),
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      });
}
