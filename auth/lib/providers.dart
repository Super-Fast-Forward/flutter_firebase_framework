import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StreamProvider<User?> authStateChangesSP =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final StreamProvider<User?> authTokenChangeSP =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.idTokenChanges());
