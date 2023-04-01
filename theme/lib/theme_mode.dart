import 'package:auth/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeStateNotifier extends StateNotifier<bool> {
  late void Function(bool) saveBuilder;
  late Future<bool> Function() getBuilder;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbInstance = FirebaseFirestore.instance;

  ThemeModeStateNotifier(bool loginState) : super(false) {
    this.saveBuilder = ThemeModeConfig.saveBuilder;
    this.getBuilder = ThemeModeConfig.getBuilder;
    if (loginState == true && auth.currentUser != null) {
      getBuilder().then((v) => {state = v});
      // dbInstance.collection('user').doc(auth.currentUser!.uid)

      //     .get()
      //     .then((value) {
      //   String theme = value['themeMode'];
      //   bool isDark = theme == 'light' ? false : true;
      //   state = isDark;
      // });
    }
  }
  void changeTheme() {
    state = !state;

    if (auth.currentUser != null) {
      saveBuilder(state);
    }
  }
}

final themeModeSNP = StateNotifierProvider<ThemeModeStateNotifier, bool>((ref) {
  bool loginState = ref.watch(authStateProvider);
  return ThemeModeStateNotifier(loginState);
}, dependencies: [isLoggedIn]);

class ThemeModeConfig {
  static bool enableSave = true;
  static Function(bool themeMode) saveBuilder = (themeMode) => FirebaseFirestore
      .instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({'themeMode': themeMode == false ? 'light' : 'dark'});
  static Future<bool> Function() getBuilder = () async {
    final theme = (await FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .data()!['themeMode'];
    print('received: $theme');
    return theme == 'light' ? false : true;
    //     .then((value) {
    //   String theme = value['themeMode'];
    //   bool isDark = theme == 'light' ? false : true;
    //   state = isDark;
    // });
  };
}
