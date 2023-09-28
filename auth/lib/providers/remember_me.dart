import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rememberMeSignIn =
    StateNotifierProvider.autoDispose<RememberMeProvider, bool>(
  (ref) {
    return RememberMeProvider();
  },
);

final rememberMeSignUp =
    StateNotifierProvider.autoDispose<RememberMeProvider, bool>(
  (ref) {
    return RememberMeProvider();
  },
);

class RememberMeProvider extends StateNotifier<bool> {
  RememberMeProvider() : super(false);

  void toggleRememberMe() {
    changeRememberMe(!state);
  }

  void changeRememberMe(bool newState) async {
    state = newState;
  }

  Future<void> updateFirebase() async {
    if (!state) {
      await FirebaseAuth.instance.setPersistence(Persistence.SESSION);
    }
  }
}
