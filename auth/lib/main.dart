library flutter_firebase_framework;

//import 'dart:ffi';

import 'package:auth/login_button.dart';
import 'package:auth/providers/firebase_auth.dart';
import 'package:auth/providers/linkedin_auth.dart';
import 'package:auth/providers/show_password_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'dart:io';

//import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:providers/generic.dart';
part 'login_widget.dart';
part 'auth_state_notifier.dart';

class AuthConfig {
  static bool enableGoogleAuth = true;
  static bool enableGithubAuth = true;
  static bool enableSsoAuth = false;
  static bool enableEmailAuth = false;
  static bool enableAnonymousAuth = true;
  static bool enableSignupOption = false;
  static bool enableLinkedinOption = true;
  static bool enableFacebookOption = true;
  static bool enableTwitterOption = true;
}
