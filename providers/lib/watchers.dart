import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

T? docWatch<T>(
        AutoDisposeStreamProvider<DocumentSnapshot<Map<String, dynamic>>>
            docStreamProvider,
        WidgetRef ref,
        Function(DocumentSnapshot<Map<String, dynamic>>) builder) =>
    ref.watch(docStreamProvider).when(
        data: (doc) => builder(doc),
        loading: () => null,
        error: (e, s) => null);

T? colWatch<T>(
        AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>>
            colStreamProvider,
        WidgetRef ref,
        Function(QuerySnapshot<Map<String, dynamic>>) builder) =>
    ref.watch(colStreamProvider).when(
        data: (col) => builder(col),
        loading: () => null,
        error: (e, s) => null);
