import 'package:auth/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isEmailSignInProvider =
    StateNotifierProvider<AuthStateNotifier<bool>, bool>(
  (ref) => AuthStateNotifier<bool>(false),
);
