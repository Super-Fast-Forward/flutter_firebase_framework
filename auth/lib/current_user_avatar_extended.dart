import 'package:auth/login.dart';
import 'package:auth/user_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentUserAvatarExtended extends ConsumerWidget {
  final Widget? child;
  const CurrentUserAvatarExtended({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
      onTap: () => FirebaseAuth.instance.currentUser == null
          ? showLoginDialog(context, ref)
          : showExtendedEditProfileDialog(context, ref, child),
      child: FirebaseAuth.instance.currentUser == null
          ? Icon(Icons.person)
          : FirebaseAuth.instance.currentUser!.isAnonymous
              ? Icon(Icons.person)
              : (FirebaseAuth.instance.currentUser?.photoURL == null
                  ? Icon(Icons.person)
                  : UserAvatar(FirebaseAuth.instance.currentUser?.photoURL)));

  void showExtendedEditProfileDialog(
      BuildContext context, WidgetRef ref, Widget? child) {
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
                        Expanded(child: child ?? Container()),
                        Text(FirebaseAuth.instance.currentUser!.displayName ??
                            ''),
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

  showLoginDialog(BuildContext context, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Login"),
              content: SizedBox(
                  height: 200.0, // Change as per your requirement
                  width: 400.0, // Change as per your requirement
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [LoginButtonsWidget(screenTitle: '')])));
        });
  }
}
