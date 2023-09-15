import 'package:flutter_riverpod/flutter_riverpod.dart';

final showPasswordProvider =
    StateNotifierProvider.autoDispose<ShowPasswordProvider, bool>(
  (ref) {
    return ShowPasswordProvider();
  },
);

class ShowPasswordProvider extends StateNotifier<bool> {
  ShowPasswordProvider() : super(false);

  void toggleTheme() {
    changeTheme(!state);
  }

  void changeTheme(bool newState) async {
    state = newState;
  }
}
