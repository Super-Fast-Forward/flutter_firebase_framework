part of flutter_firebase_framework;

class AuthStateNotifier<V> extends StateNotifier<V> {
  AuthStateNotifier(V d) : super(d);

  set value(V v) {
    state = v;
  }

  V get value => state;
}

final isLoggedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

final isLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(true));
