library flutter_firebase_framework;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:providers/generic.dart';
part 'login_buttons_widget.dart';
part 'auth_state_notifier.dart';

class AuthConfig {
  static bool enableGoogleAuth = true;
  static bool enableGithubAuth = false;
  static bool enableSsoAuth = false;
  static bool enableEmailAuth = false;
  static bool enableAnonymousAuth = true;
  static bool enableSignupOption = false;
}
