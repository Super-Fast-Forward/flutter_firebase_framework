import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef DS = DocumentSnapshot<Map<String, dynamic>>;
typedef DR = DocumentReference<Map<String, dynamic>>;
typedef CR = CollectionReference<Map<String, dynamic>>;

final kDB = FirebaseFirestore.instance;
final kUSR = FirebaseAuth.instance.currentUser;
