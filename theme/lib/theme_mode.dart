import 'package:auth/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme/config.dart';
import 'package:theme/local_storage/local_storage_export.dart';

class ThemeModeStateNotifier extends StateNotifier<bool> {
  ThemeModeStateNotifier({required this.ref}) : super(false) {
    getTheme();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final Ref ref;

  void getTheme() async {
    if (ref.watch(authStateProvider).isLoaded || auth.currentUser != null) {
      final theme = await ThemeModeConfig.getTheme();
      state = theme;
    } else {
      final value = await LocalStorage.getDataFromKey(LocalStorageKeys.theme);
      state = (value == "true");
    }
  }

  void toggleTheme() {
    changeTheme(!state);
  }

  void changeTheme(bool newState) async {
    state = newState;
    print(state.toString());
    LocalStorage.saveDataFromKey(LocalStorageKeys.theme, state.toString());
    if (ref.read(authStateProvider).isLoaded || auth.currentUser != null) {
      await ThemeModeConfig.saveTheme(state);
    }
  }
}

final themeModeSNP = StateNotifierProvider<ThemeModeStateNotifier, bool>(
  (ref) {
    return ThemeModeStateNotifier(ref: ref);
  },
);
