Welcome to **flutter-firestore-providers**

This is a library of shortcut functions to simplify the use of [Firestore] collections and documents when working with [Riverpod].

Long story short, instead of:

```dart

  Query<Map<String, dynamic>> q =
      FirebaseFirestore.instance.collection('some_col_path');

  if (filter.queries != null)
    filter.queries!.forEach((query) {
      q = Function.apply(q.where, [query.field], query.params);
    });

  if (filter.orderBy != null)
    q = q.orderBy(filter.orderBy!, descending: filter.isOrderDesc ?? false);

  if (filter.limit != null) q = q.limit(filter.limit!);

  ref.watch(filter.distinct == null
      ? q.snapshots()
      : q.snapshots().distinct(filter.distinct))
    .when(
      loading: () => [Container()],
      error: (e, s) => [ErrorWidget(e)],
      data: (data)...

```

simply write:

```dart

ref.watch(colSPfiltered(
  'some_col_path',
  queries: [
    QueryParam(
      'field',
      Map<Symbol, dynamic>.from({Symbol('isEqualTo'): 'some_value'})),
  orderBy: 'field',
  limit: 100,
  distinct: ((previous, current) {
      return previous.size == current.size;
    })
))
.when(
    loading: () => [Container()],
    error: (e, s) => [ErrorWidget(e)],
    data: (data)...

```

## Motivation

These functions should make your code more readable and declarative. It should save you time when working a lot with collections and docs, especially querying collections with parameters.

## FAQ

### are the parameters watchable?

Yes, you can update all the parameters dynamically and the collection will be refreshed without any extra effort:

```dart
  colSPfiltered(
    'some_col_path/${some_doc_id}/sub_col',
```


