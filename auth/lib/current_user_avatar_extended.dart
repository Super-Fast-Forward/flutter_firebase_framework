import 'package:auth/show_edit_profile.dart';
import 'package:auth/user_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentUserAvatarExtended extends ConsumerWidget {
  Widget? child;
  CurrentUserAvatarExtended({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => FirebaseAuth
              .instance.currentUser ==
          null
      ? Icon(Icons.person)
      : GestureDetector(
          onTap: () => showExtendedEditProfileDialog(context, ref, child),
          child: FirebaseAuth.instance.currentUser!.isAnonymous
              ? Icon(Icons.person)
              : (FirebaseAuth.instance.currentUser?.photoURL == null
                  ? Icon(Icons.person)
                  : UserAvatar(FirebaseAuth.instance.currentUser?.photoURL)));
}
