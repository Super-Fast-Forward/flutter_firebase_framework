import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rememberMe = StateNotifierProvider.autoDispose<RememberMeProvider, bool>(
  (ref) {
    return RememberMeProvider();
  },
);

class RememberMeProvider extends StateNotifier<bool> {
  RememberMeProvider() : super(false);

  void toggleTheme() {
    changeTheme(!state);
  }

  void changeTheme(bool newState) async {
    state = newState;
  }

  Future<void> updateFirebase() async {
    if (!state) {
      await FirebaseAuth.instance.setPersistence(Persistence.SESSION);
    }
  }
}
