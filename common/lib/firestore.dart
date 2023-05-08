import 'package:cloud_firestore/cloud_firestore.dart';

import 'common.dart';

/// Copies all documents from one collection to another.
Future<void> copyCol(
    CollectionReference source, CollectionReference destination) async {
  QuerySnapshot querySnapshot = await source.get();
  querySnapshot.docs.forEach((doc) async {
    await destination.doc(doc.id).set(doc.data());
  });
}

copyColInTransaction(QS source, CR dest, Transaction transaction) {
  for (var doc in source.docs) {
    transaction.set(dest.doc(doc.id), doc.data());
  }
}

/// Deletes all documents in a collection.
Future<void> deleteCol(CollectionReference ref) async {
  var batch = FirebaseFirestore.instance.batch();
  var counter = 0;

  var c = await ref.get();
  for (var l in c.docs) {
    batch.delete(l.reference);
    counter++;
    if (counter > 490) {
      await batch.commit();
      batch = FirebaseFirestore.instance.batch();
      counter = 0;
    }
  }
  await batch.commit();
}
