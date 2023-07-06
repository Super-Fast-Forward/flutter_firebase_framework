import 'package:auth/main.dart';
import 'package:auth/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config.dart';

class ThemeModeStateNotifier extends StateNotifier<bool> {
  late void Function(bool) saveBuilder;
  late Future<bool> Function() getBuilder;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbInstance = FirebaseFirestore.instance;

  ThemeModeStateNotifier(AuthState authState) : super(false) {
    this.saveBuilder = ThemeModeConfig.saveBuilder;
    this.getBuilder = ThemeModeConfig.getBuilder;
    if (authState.isLoaded == true && auth.currentUser != null) {
      getBuilder().then((v) {
        // print('mounted: ${mounted}');
        if (!mounted) {
          state = v;
        }
      });
      // dbInstance.collection('user').doc(auth.currentUser!.uid)

      //     .get()
      //     .then((value) {
      //   String theme = value['themeMode'];
      //   bool isDark = theme == 'light' ? false : true;
      //   state = isDark;
      // });
    }

    state = ThemeModeConfig.defaultToLightTheme ? true : false;
  }
  void changeTheme() {
    state = !state;

    if (auth.currentUser != null) {
      saveBuilder(state);
    }
  }
}

final themeModeSNP = StateNotifierProvider<ThemeModeStateNotifier, bool>(
  (ref) {
    AuthState loginState = ref.watch(authStateProvider);
    return ThemeModeStateNotifier(loginState);
  },
// dependencies: [isLoggedIn]
);
