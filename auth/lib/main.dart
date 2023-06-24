library flutter_firebase_framework;

//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_admin/firebase_admin.dart';
//import 'package:firebase_admin/src/auth/token_generator.dart';
//import 'package:firebase_admin/src/auth/credential.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
//import 'package:firebase_dart/firebase_dart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'dart:io';

//import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:providers/generic.dart';
part 'login_buttons_widget.dart';
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
