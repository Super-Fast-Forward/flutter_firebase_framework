import 'package:auth/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeStateNotifier extends StateNotifier<bool> {
  late DocumentReference Function() saveDocRefBuilder;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbInstance = FirebaseFirestore.instance;

  ThemeModeStateNotifier(bool loginState) : super(false) {
    this.saveDocRefBuilder =
        () => dbInstance.collection('user').doc(auth.currentUser!.uid);
    if (loginState == true && auth.currentUser != null) {
      dbInstance
          .collection('user')
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
        String theme = value['themeMode'];
        bool isDark = theme == 'light' ? false : true;
        state = isDark;
      });
    }
  }
  void changeTheme() {
    state = !state;

    String themeMode = state == false ? 'light' : 'dark';
    if (auth.currentUser != null) {
      dbInstance
          .collection('user')
          .doc(auth.currentUser!.uid)
          .set({'themeMode': themeMode});
    }
  }
}

final themeModeSNP = StateNotifierProvider<ThemeModeStateNotifier, bool>((ref) {
  bool loginState = ref.watch(isLoggedIn);
  return ThemeModeStateNotifier(loginState);
}, dependencies: [isLoggedIn]);
