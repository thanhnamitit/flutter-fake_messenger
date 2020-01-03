import 'dart:async';

import 'package:flutter/foundation.dart';

class BaseViewModel with ChangeNotifier {
  List<StreamSubscription> disposables = [];

  void _manageStreamSubscription(StreamSubscription source) {
    disposables.add(source);
  }

  @override
  void dispose() {
    disposables.forEach((it) => it.cancel());
    disposables.clear();
    super.dispose();
  }
}

extension StringExtension on StreamSubscription {
  void autoDispose(BaseViewModel viewModel) {
    viewModel._manageStreamSubscription(this);
  }
}

extension StreamExtension on Stream {
  void execute(BaseViewModel viewModel, Function callback) {
    this.listen((it) {
      callback(it);
    }).autoDispose(viewModel);
  }
}
