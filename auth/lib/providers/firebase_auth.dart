import 'dart:async';
import 'package:auth/providers/is_email_sign_in_provider.dart';
import 'package:auth/providers/remember_me.dart';
import 'package:auth/toast.dart';
import 'package:auth/utils/firebase_exception_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider =
    StateNotifierProvider<FirebaseAuthProvider, String>(
  (ref) {
    return FirebaseAuthProvider(ref);
  },
);

class FirebaseAuthProvider extends StateNotifier<String> {
  FirebaseAuthProvider(this._ref) : super('');

  final Ref _ref;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    await signIn(
      func: () {
        final result = FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        _ref.read(isEmailSignInProvider.notifier).value = true;
        return result;
      },
    );
    await _ref.read(rememberMeSignIn.notifier).updateFirebase();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await signIn(
      func: () {
        final result = FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _ref.read(isEmailSignInProvider.notifier).value = true;
        return result;
      },
    );
    await _ref.read(rememberMeSignUp.notifier).updateFirebase();
  }

  // Auth page: https://github.com/settings/applications
  Future<void> signInWithGitHub() async {
    await signIn(
      func: () {
        GithubAuthProvider githubAuthProvider = GithubAuthProvider();
        return FirebaseAuth.instance.signInWithPopup(
          githubAuthProvider,
        );
      },
    );
  }

  //https://developer.twitter.com/en/portal/projects/1672405934805745666/apps/27364500/settings
  Future<void> signInWithFacebook() async {
    await signIn(
      func: () {
        FacebookAuthProvider facebookAuthProvider = FacebookAuthProvider();
        return FirebaseAuth.instance.signInWithPopup(
          facebookAuthProvider,
        );
      },
    );
  }

  Future<void> signInWithTwitter() async {
    await signIn(func: () {
      TwitterAuthProvider twitterAuthProvider = TwitterAuthProvider();
      if (kIsWeb) {
        return FirebaseAuth.instance.signInWithPopup(
          twitterAuthProvider,
        );
      }
      return FirebaseAuth.instance.signInWithProvider(
        twitterAuthProvider,
      );
    });
  }

  Future<void> signInWithGoogle({bool localPersistanceEnabled = false}) async {
    signIn(
      func: () {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return FirebaseAuth.instance.signInWithPopup(googleProvider);
      },
      localPersistanceEnabled: localPersistanceEnabled,
    );
  }

  Future<void> signIn({
    required Future<UserCredential> Function() func,
    bool localPersistanceEnabled = false,
  }) async {
    try {
      _ref.read(isEmailSignInProvider.notifier).value = false;
      final result = await func();
      if (localPersistanceEnabled) {
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      }
      linkAccount(result.credential);
      await checkUserExists(result);
    } on FirebaseAuthException catch (e) {
      Toast.show(
        message: getFirebaseMessageFromErrorCode(e.code),
      );
    } catch (e) {
      Toast.show(
        message: getFirebaseMessageFromErrorCode(""),
      );
    }
  }

  Future<UserCredential?> linkAccount(AuthCredential? credential) async {
    try {
      if (credential != null) {
        final userCredential = await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential);
        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          Toast.show(
              message: "The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          Toast.show(message: "The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          Toast.show(message: "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          Toast.show(message: "Unknown error.");
      }
    }
    return null;
  }

  Future<void> checkUserExists(UserCredential result) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Access the signed-in user's information
      final user = result.user;
      final displayName = user?.displayName;
      final email = user?.email;
      final photoURL = user?.photoURL;

      // Deteremine if the user exits
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(currentUser.uid)
          .get();

      if (!userSnapshot.exists) {
        await saveDataFirebase(
          currentUser.uid,
          email ?? "",
          photoURL ?? "",
          displayName ?? "",
        );
      }
    } else {
      Toast.show(message: "current user is null");
    }
  }

  Future<void> saveDataFirebase(
    String uid,
    String email,
    String pictureURL,
    String userName,
  ) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('user').doc(uid);
      await userRef.set({
        'email': email,
        'pictureURL': pictureURL,
        'userName': userName,
      }, SetOptions(merge: true));
    } catch (e) {
      Toast.show(message: 'Error creating user: $e');
    }
  }
}
