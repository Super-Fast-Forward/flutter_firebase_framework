import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThemeModeConfig {
  static bool enableSave = true;
  static bool defaultToLightTheme = false;
  static Function(bool themeMode) saveBuilder = (themeMode) => FirebaseFirestore
      .instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({'themeMode': themeMode == false ? 'light' : 'dark'},
          SetOptions(merge: true));
  static Future<bool> Function() getBuilder = () async {
    final theme = (await FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .data()!['themeMode'];
    return theme == 'light' ? false : true;
  };
}
