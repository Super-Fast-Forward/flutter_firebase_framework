import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

typedef DS = DocumentSnapshot<Map<String, dynamic>>;
typedef QS = QuerySnapshot<Map<String, dynamic>>;
typedef DR = DocumentReference<Map<String, dynamic>>;
typedef CR = CollectionReference<Map<String, dynamic>>;

final kDB = FirebaseFirestore.instance;
final kUSR = FirebaseAuth.instance.currentUser;

final FFI = FirebaseFirestore.instance;
final FAI = FirebaseAuth.instance;

final USER = FirebaseAuth.instance.currentUser;
final DB = FirebaseFirestore.instance;

const WIDE_SCREEN_WIDTH = 600;

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

/// returns a formatted date string
String formatDate(Timestamp? dateTime) {
  if (dateTime == null) return '';
  return Jiffy(dateTime.toDate()).format(dateFormat);
}

/// returns a formatted date time string
String formatDateTime(Timestamp? dateTime) {
  if (dateTime == null) return '';
  return Jiffy(dateTime.toDate()).format(dateTimeFormat);
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
