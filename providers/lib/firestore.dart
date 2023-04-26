import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Query parameter for [WhereFilter] used in [filteredColSP]
///
/// Example:
///
/// ref.watch(filteredColSP(WhereFilter(
///     limit: 5,
///     path: 'path to collection',
///     queries: [
///   QueryParam(
///       'entity',
///       Map<Symbol, dynamic>.from(
///           {Symbol('isEqualTo'): caseDoc.get('entity')}))
///
/// Available values:
/// final dynamic isEqualTo;
/// final dynamic isNotEqualTo;
/// final dynamic isLessThan;
/// final dynamic isLessThanOrEqualTo;
/// final dynamic isGreaterThan;
/// final dynamic isGreaterThanOrEqualTo;
/// final dynamic arrayContains;
/// final List<dynamic>? arrayContainsAny;
/// final List<dynamic>? whereIn;
/// final List<dynamic>? whereNotIn;
class QueryParam extends Equatable {
  final dynamic field;
  final Map<Symbol, dynamic> params;

  const QueryParam(
    this.field,
    this.params,
  );

  @override
  List<Object?> get props => [
        field,
        ...params.entries
            .map((e) => e.key.toString() + ":" + e.value.toString())
            .toList()
      ];
}

class QueryParam2 extends Equatable {
  final dynamic field;
  // final Map<Symbol, dynamic> params;
  final Object? isEqualTo;
  final Object? isNotEqualTo;
  final Object? isLessThan;
  final Object? isLessThanOrEqualTo;
  final Object? isGreaterThan;
  final Object? isGreaterThanOrEqualTo;
  final Object? arrayContains;
  final List<Object?>? arrayContainsAny;
  final List<Object?>? whereIn;
  final List<Object?>? whereNotIn;

  const QueryParam2(
    this.field,
    // this.params,
    {
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
  });

  @override
  List<Object?> get props => [
        field,
        // ...params.entries
        //     .map((e) => e.key.toString() + ":" + e.value.toString())
        //     .toList(),
        isEqualTo,
        isNotEqualTo,
        isLessThan,
        isLessThanOrEqualTo,
        isGreaterThan,
        isGreaterThanOrEqualTo,
        arrayContains,
        arrayContainsAny,
        whereIn,
        whereNotIn,
      ];
}

enum QueryOperator {
  isEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  whereIn,
  whereNotIn,
  isNull,
}

/// Filter for collection when listening to [filteredColSP]
///
/// Example:
///
/// ref.watch(filteredColSP(WhereFilter(
///     limit: 5,
///     path: 'path to collection',
///     queries: [
///   QueryParam(
///       'entity',
///       Map<Symbol, dynamic>.from(
///           {Symbol('isEqualTo'): caseDoc.get('entity')}))
class QueryParams extends Equatable {
  const QueryParams(this.path,
      {this.queries,
      this.orderBy,
      this.isOrderDesc,
      this.limit,
      this.distinct});

  final dynamic path;
  final List<QueryParam>? queries;
  final String? orderBy;
  final bool? isOrderDesc;
  final int? limit;
  final bool Function(QuerySnapshot a, QuerySnapshot<Map<String, dynamic>> b)?
      distinct;

  @override
  List<Object?> get props => [
        path,
        ...(queries == null ? [] : queries!.map((qp) => qp..props).toList()),
        orderBy,
        limit
      ];
}

class QueryParams2 extends Equatable {
  const QueryParams2(this.path,
      {this.queries,
      this.orderBy,
      this.isOrderDesc,
      this.limit,
      this.distinct});

  final dynamic path;
  final List<QueryParam2>? queries;
  final String? orderBy;
  final bool? isOrderDesc;
  final int? limit;
  final bool Function(QuerySnapshot a, QuerySnapshot<Map<String, dynamic>> b)?
      distinct;

  @override
  List<Object?> get props => [
        path,
        ...(queries == null ? [] : queries!.map((qp) => qp..props).toList()),
        orderBy,
        limit
      ];
}

// class QueryParams3 extends Equatable {
//   const QueryParams3(this.path,
//       {this.queries,
//       this.orderBy,
//       this.isOrderDesc,
//       this.limit,
//       this.distinct});

//   final dynamic path;
//   final List<QueryParam3>? queries;
//   final String? orderBy;
//   final bool? isOrderDesc;
//   final int? limit;
//   final bool Function(QuerySnapshot a, QuerySnapshot<Map<String, dynamic>> b)?
//       distinct;

//   @override
//   List<Object?> get props => [
//         path,
//         ...(queries == null ? [] : queries!.map((qp) => qp..props).toList()),
//         orderBy,
//         limit
//       ];
// }

AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> colSPfiltered(
        String path,
        {List<QueryParam>? queries,
        String? orderBy,
        bool? isOrderDesc,
        bool? descending,
        int? limit,
        bool Function(
                QuerySnapshot<Object?>, QuerySnapshot<Map<String, dynamic>>)?
            distinct}) =>
    filteredColSP(QueryParams(path,
        queries: queries,
        orderBy: orderBy,
        distinct: distinct,
        limit: limit,
        isOrderDesc: isOrderDesc ?? descending));

/// Riverpod Stream Provider that listens to a collection with specific query criteria
/// (see [QueryParams]) and [equals] function that is used by [Stream.distinct] to
/// filter out events with unrelated changes.
final AutoDisposeStreamProviderFamily<QuerySnapshot<Map<String, dynamic>>,
        QueryParams> filteredColSP =
    StreamProvider.autoDispose
        .family<QuerySnapshot<Map<String, dynamic>>, QueryParams>(
            (ref, filter) {
  Query<Map<String, dynamic>> q =
      FirebaseFirestore.instance.collection(filter.path);

  if (filter.queries != null)
    filter.queries!.forEach((query) {
      q = Function.apply(q.where, [query.field], query.params);
    });

  if (filter.orderBy != null)
    q = q.orderBy(filter.orderBy!, descending: filter.isOrderDesc ?? false);

  if (filter.limit != null) q = q.limit(filter.limit!);

  return filter.distinct == null
      ? q.snapshots()
      : q.snapshots().distinct(filter.distinct);
});

final f = colSPfiltered2('path to collection',
    queries: [QueryParam2('entity', isEqualTo: 'test')]);

/// Riverpod Stream Provider that listens to a collection with specific query criteria
/// (see [QueryParams]) and [equals] function that is used by [Stream.distinct] to
/// filter out events with unrelated changes.
final AutoDisposeStreamProviderFamily<QuerySnapshot<Map<String, dynamic>>,
        QueryParams2> filteredColSP2 =
    StreamProvider.autoDispose
        .family<QuerySnapshot<Map<String, dynamic>>, QueryParams2>(
            (ref, filter) {
  Query<Map<String, dynamic>> q =
      FirebaseFirestore.instance.collection(filter.path);

  if (filter.queries != null)
    filter.queries!.forEach((query) {
      Map<Symbol, dynamic>? params;
      if (query.arrayContains != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('arrayContains'): query.arrayContains});
      } else if (query.arrayContainsAny != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('arrayContainsAny'): query.arrayContainsAny});
      } else if (query.isEqualTo != null) {
        params =
            Map<Symbol, dynamic>.from({Symbol('isEqualTo'): query.isEqualTo});
      } else if (query.isGreaterThan != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('isGreaterThan'): query.isGreaterThan});
      } else if (query.isGreaterThanOrEqualTo != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('isGreaterThanOrEqualTo'): query.isGreaterThanOrEqualTo});
      } else if (query.isLessThan != null) {
        params =
            Map<Symbol, dynamic>.from({Symbol('isLessThan'): query.isLessThan});
      } else if (query.isLessThanOrEqualTo != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('isLessThanOrEqualTo'): query.isLessThanOrEqualTo});
      } else if (query.isNotEqualTo != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('isNotEqualTo'): query.isNotEqualTo});
      } else if (query.whereIn != null) {
        params = Map<Symbol, dynamic>.from({Symbol('whereIn'): query.whereIn});
      } else if (query.whereNotIn != null) {
        params =
            Map<Symbol, dynamic>.from({Symbol('whereNotIn'): query.whereNotIn});
      }

      if (params != null) q = Function.apply(q.where, [query.field], params);
    });

  if (filter.orderBy != null)
    q = q.orderBy(filter.orderBy!, descending: filter.isOrderDesc ?? false);

  if (filter.limit != null) q = q.limit(filter.limit!);

  return filter.distinct == null
      ? q.snapshots()
      : q.snapshots().distinct(filter.distinct);
});

AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> colSPfiltered2(
        String path,
        {
        //List<QueryParam>? queries,
        List<QueryParam2>? queries,
        String? orderBy,
        bool? isOrderDesc,
        int? limit,
        bool Function(
                QuerySnapshot<Object?>, QuerySnapshot<Map<String, dynamic>>)?
            distinct}) =>
    filteredColSP2(QueryParams2(path,
        queries: queries,
        orderBy: orderBy,
        distinct: distinct,
        limit: limit,
        isOrderDesc: isOrderDesc));

/// Riverpod Stream Provider that listens to a collection with specific query criteria
/// (see [QueryParams]) and [equals] function that is used by [Stream.distinct] to
/// filter out events with unrelated changes.
final AutoDisposeStreamProviderFamily<QuerySnapshot<Map<String, dynamic>>,
        QueryParams2> filteredColSP3 =
    StreamProvider.autoDispose
        .family<QuerySnapshot<Map<String, dynamic>>, QueryParams2>(
            (ref, filter) {
  Query<Map<String, dynamic>> q =
      FirebaseFirestore.instance.collection(filter.path);

  if (filter.queries != null)
    filter.queries!.forEach((query) {
      Map<Symbol, dynamic>? params;
      if (query.arrayContains != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('arrayContains'): query.arrayContains});
      } else if (query.arrayContainsAny != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('arrayContainsAny'): query.arrayContainsAny});
      } else if (query.isEqualTo != null) {
        params =
            Map<Symbol, dynamic>.from({Symbol('isEqualTo'): query.isEqualTo});
      } else if (query.isGreaterThan != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('isGreaterThan'): query.isGreaterThan});
      } else if (query.isGreaterThanOrEqualTo != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('isGreaterThanOrEqualTo'): query.isGreaterThanOrEqualTo});
      } else if (query.isLessThan != null) {
        params =
            Map<Symbol, dynamic>.from({Symbol('isLessThan'): query.isLessThan});
      } else if (query.isLessThanOrEqualTo != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('isLessThanOrEqualTo'): query.isLessThanOrEqualTo});
      } else if (query.isNotEqualTo != null) {
        params = Map<Symbol, dynamic>.from(
            {Symbol('isNotEqualTo'): query.isNotEqualTo});
      } else if (query.whereIn != null) {
        params = Map<Symbol, dynamic>.from({Symbol('whereIn'): query.whereIn});
      } else if (query.whereNotIn != null) {
        params =
            Map<Symbol, dynamic>.from({Symbol('whereNotIn'): query.whereNotIn});
      }

      if (params != null) q = Function.apply(q.where, [query.field], params);
    });

  if (filter.orderBy != null)
    q = q.orderBy(filter.orderBy!, descending: filter.isOrderDesc ?? false);

  if (filter.limit != null) q = q.limit(filter.limit!);

  return filter.distinct == null
      ? q.snapshots()
      : q.snapshots().distinct(filter.distinct);
});

// AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> colSPfiltered3(
//         String path,
//         {Map<String, Map<QueryOperator, Object>>? queries,
//         String? orderBy,
//         bool? isOrderDesc,
//         int? limit,
//         bool Function(
//                 QuerySnapshot<Object?>, QuerySnapshot<Map<String, dynamic>>)?
//             distinct}) =>
//     filteredColSP3(QueryParams2(path,
//         queries: queries.entries.map((q) => QueryParam2(
//             field: q.key,
//             operator: q.value.keys.first,
//             value: q.value.values.first)).toList(),
//         orderBy: orderBy,
//         distinct: distinct,
//         limit: limit,
//         isOrderDesc: isOrderDesc));

/// Riverpod Provider listening to a Firestore document by the path specified
/// [path] is the path to the document
///
final AutoDisposeStreamProviderFamily<DocumentSnapshot<Map<String, dynamic>>,
        String> docSP =
    StreamProvider.autoDispose
        .family<DocumentSnapshot<Map<String, dynamic>>, String>((ref, path) {
  return FirebaseFirestore.instance.doc(path).snapshots();
});

/// DocParam is used only to pass parameters (path and equals function)
/// to distinct stream providers (docSPdistinct and colSPdistinct)
@immutable
class DocParam {
  final String path;
  final bool Function(DocumentSnapshot<Map<String, dynamic>>,
      DocumentSnapshot<Map<String, dynamic>>)? equals;

  const DocParam(this.path, this.equals);

  @override
  int get hashCode {
    return Object.hashAll([path]);
  }

  @override
  bool operator ==(Object other) {
    return path == (other as DocParam).path;
  }
}

/// Riverpod Provider listening to a Firestore document by the path specified
/// with distinct function if you need to filter our unnecessarry changes.
final AutoDisposeStreamProviderFamily<DocumentSnapshot<Map<String, dynamic>>,
        DocParam> docSPdistinct =
    StreamProvider.autoDispose
        .family<DocumentSnapshot<Map<String, dynamic>>, DocParam>((ref, param) {
  return FirebaseFirestore.instance
      .doc(param.path)
      .snapshots()
      .distinct(param.equals);
});

/// Riverpod Provider that fetches a document once, as a promise.
final AutoDisposeFutureProviderFamily<DocumentSnapshot<Map<String, dynamic>>,
        String> docFP =
    FutureProvider.autoDispose
        .family<DocumentSnapshot<Map<String, dynamic>>, String>((ref, path) {
  return FirebaseFirestore.instance.doc(path).get();
});

/// Riverpod Provider that fetches a collection once, as a promise.
///
/// WARNING: Use with care as it returns all the documents in the collection!
/// Only to be used on collections which size is known to be small.
final AutoDisposeFutureProviderFamily<QuerySnapshot<Map<String, dynamic>>,
        String> colFP =
    FutureProvider.autoDispose
        .family<QuerySnapshot<Map<String, dynamic>>, String>((ref, path) {
  return FirebaseFirestore.instance.collection(path).get();
});

/// Riverpod collection Stream Provider that listens to a collection
///
/// WARNING: Use with care as it returns all the documents in the collection
/// whenever any document in collection changes!
/// Only to be used on collections which size is known to be small
///
/// To work with large collections consider using [filteredColSP]
final AutoDisposeStreamProviderFamily<QuerySnapshot<Map<String, dynamic>>,
        String> colSP =
    StreamProvider.autoDispose
        .family<QuerySnapshot<Map<String, dynamic>>, String>((ref, path) {
  return FirebaseFirestore.instance.collection(path).snapshots();
});

// To get the count of a collection
final AutoDisposeStreamProviderFamily<AggregateQuerySnapshot, String> count =
    StreamProvider.autoDispose
        .family<AggregateQuerySnapshot, String>((ref, path) {
  return FirebaseFirestore.instance.collection(path).count().get().asStream();
});
