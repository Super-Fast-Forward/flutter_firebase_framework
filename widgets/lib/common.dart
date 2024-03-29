import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stack_trace/stack_trace.dart';

typedef DS = DocumentSnapshot<Map<String, dynamic>>;
typedef QS = QuerySnapshot<Map<String, dynamic>>;
typedef DR = DocumentReference<Map<String, dynamic>>;
typedef CR = CollectionReference<Map<String, dynamic>>;

final kDB = FirebaseFirestore.instance;
final kUSR = FirebaseAuth.instance.currentUser;

DR kDBUserRef() => FirebaseFirestore.instance.doc('user/${kUSR!.uid}');
// userDocSP(String path) => docSP('user/${kUSR!.uid}/${path}');

final FFI = FirebaseFirestore.instance;
final FAI = FirebaseAuth.instance;

final USER = FirebaseAuth.instance.currentUser;
final DB = FirebaseFirestore.instance;

const SCREEN_WIDTH = 600;

String formatFirestoreDoc(DS doc) {
  String jsonString = json.encode(doc.data(), toEncodable: (o) {
    if (o is Timestamp) {
      return Jiffy(o.toDate()).format('yyyy-MM-dd HH:mm:ss');
    }
    return o;
  });
  return JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString));
}

/// Returns a string with the first [length] characters of [str].
String stringLeft(String str, int length) {
  if (str.length > length) {
    return str.substring(0, length);
  } else {
    return str;
  }
}

const dateFormat = 'yyyy-MM-dd';
const dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

///
/// Formats Firestore Timestamp to a date string
///
String formatDate(Timestamp? dateTime, {String format = dateFormat}) {
  if (dateTime == null) return '';
  return Jiffy(dateTime.toDate()).format(format);
}

///
/// Formats Firestore Timestamp to a date time string
///
String formatDateTime(Timestamp? dateTime, {String format = dateTimeFormat}) {
  if (dateTime == null) return '';
  return Jiffy(dateTime.toDate()).format(format);
}

Color Function(String color) getColor = (String color) {
  // color comes as a string  4294967295
  // 0xFF000000
  // return Color(int.parse(color));
  try {
    return Color(int.parse(color));
  } catch (e) {
    return Colors.black;
  }
};

final padding8 = EdgeInsets.all(8);

condenseError(error, Chain chain) {
  return chain.foldFrames((Frame p0) {
    // print(
    //     'fold uri:${p0.uri}, lib:${p0.library}, core:${p0.isCore}, location:${p0.location}, package:${p0.package}, member:${p0.member}');
    return p0.location.contains('framework.dart') ||
        p0.location.contains('dart-sdk') ||
        p0.location.contains('_engine') ||
        p0.location.contains('_internal') ||
        p0.location.contains('flutter') ||
        p0.location.contains('stack_trace') ||
        p0.location.contains('.js');
  }, terse: true);
}
