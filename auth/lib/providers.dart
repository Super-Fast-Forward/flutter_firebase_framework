import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StreamProvider<User?> authStateChangesSP =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final StreamProvider<User?> authTokenChangeSP =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.idTokenChanges());

// final isInitiallySignedInProvider = Provider<bool>((ref) {
//   final authState = ref.watch(authStateChangesSP);

//   print('authState: $authState');
//   // Return true if the user is initially signed in, otherwise return false
//   return authState.when(
//     data: (user) => AsyncValue.data(user).value != null,
//     loading: () => false,
//     error: (_, __) => false,
//   );
// });

final isAuthInitializedProvider = StateProvider<bool>((ref) {
  return false;
});

final isLoadedProvider = Provider<bool>((ref) {
  // This is needed in case user doesn't listen to this provider
  // Otherwise the authStateChangesProvider will not set the isInitializedProvider state to true
  final user = ref.watch(authStateChangesProvider).value;

  final isInitialized = ref.watch(isAuthInitializedProvider);
  // print('isInitialized: $isInitialized');
  // Return true if the provider has been initialized, otherwise return false
  return isInitialized;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  // Obtain the isInitializedProvider.notifier
  final isInitializedNotifier = ref.read(isAuthInitializedProvider.notifier);

  return FirebaseAuth.instance.authStateChanges().map((user) {
    // Set the isInitializedProvider state to true once the first value is emitted
    isInitializedNotifier.state = true;
    // print('isInitializedNotifier.state: ${isInitializedNotifier.state}');

    // ref.read(isInitializedNotifier)=true;
    return user;
  });
});

class AuthState {
  final bool isLoaded;
  final User? user;

  AuthState({required this.isLoaded, this.user});
}

final authStateProvider = Provider<AuthState>((ref) {
  final isInitialized = ref.watch(isAuthInitializedProvider);
  final user = ref.watch(authStateChangesProvider).value;

  return AuthState(isLoaded: isInitialized, user: user);
});
