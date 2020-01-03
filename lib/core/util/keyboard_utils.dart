import 'package:flutter/material.dart';

class KeyboardUtils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
