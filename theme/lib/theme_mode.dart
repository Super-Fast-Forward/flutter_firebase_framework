import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme/local_storage/local_storage_export.dart';

class ThemeModeStateNotifier extends StateNotifier<bool> {
  ThemeModeStateNotifier() : super(false) {
    getTheme();
  }

  void getTheme() {
    final value = LocalStorage.getDataFromKey(LocalStorageKeys.theme);
    state = (value == true.toString());
  }

  void toggleTheme() {
    changeTheme(!state);
  }

  void changeTheme(bool newState) async {
    state = newState;
    await LocalStorage.saveDataFromKey(
      LocalStorageKeys.theme,
      state.toString(),
    );
  }
}

final themeModeSNP = StateNotifierProvider<ThemeModeStateNotifier, bool>(
  (ref) {
    return ThemeModeStateNotifier();
  },
);
