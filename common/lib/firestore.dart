import 'package:cloud_firestore/cloud_firestore.dart';

copyCollection(
    CollectionReference source, CollectionReference destination) async {
  QuerySnapshot querySnapshot = await source.get();
  querySnapshot.docs.forEach((doc) async {
    await destination.doc(doc.id).set(doc.data());
  });
}
