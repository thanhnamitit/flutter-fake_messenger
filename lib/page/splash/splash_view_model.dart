import 'package:flutter/foundation.dart';

class SplashViewModel with ChangeNotifier {
  SplashViewModel() {
    _initSplash();
  }

  bool _updateSuccessful = false;

  bool get updateSuccessful {
    return _updateSuccessful;
  }

  void _initSplash() {
    Future.delayed(Duration(seconds: 3)).then((it) {
      _updateSuccessful = true;
      notifyListeners();
    });
  }
}
