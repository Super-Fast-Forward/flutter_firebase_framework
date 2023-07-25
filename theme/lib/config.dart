import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// true for light
class ThemeModeConfig {
  static bool defaultToLightTheme = true;

  /// this function used for save themeData to firestore if any exception happens it returns false otherwise true
  static Future<bool> saveTheme(bool themeData) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
        {'themeMode': themeData ? 'light' : 'dark'},
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getTheme() async {
    final theme = (await FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .data()!['themeMode'];
    return theme == 'light';
  }
}
