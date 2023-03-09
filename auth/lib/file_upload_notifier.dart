import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class FileUploadNotifier extends StateNotifier<TaskState?> {
  FileUploadNotifier() : super(null);

  StreamSubscription<TaskSnapshot>? _tickerSubscription;

  late UploadTask _uploadTask;
  set uploadTask(t) {
    _uploadTask = t;

    if (t == null) {
      return;
    }

    if (_tickerSubscription != null) _tickerSubscription!.cancel();

    state = TaskState.running;

    _tickerSubscription = _uploadTask.asStream().listen((event) {
      // print('upload state $event');
      state = event.state;
    }, onError: (error) {
      print('upload error $error');
    }, onDone: () {
      // print('upload done!');
      if (_tickerSubscription != null) _tickerSubscription!.cancel();
    }, cancelOnError: true);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
