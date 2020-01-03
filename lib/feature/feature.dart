import 'package:flutter/foundation.dart';

class Feature {
  final String key;
  final String title;
  final String description;
  final bool defaultValue;

  Feature(this.key, this.title, this.description, this.defaultValue);

  bool isEnabled() {
    return defaultValue;
  }
}

class TestSetting extends Feature {
  TestSetting({
    @required String key,
    @required String title,
    @required String description,
    @required bool defaultValue,
  }) : super(key, title, description, defaultValue);
  static final ENABLE_RELOAD_BUTTON_AT_HOME_PAGE = TestSetting(
      key: "enable_reload_button_at_home",
      title: "Enable reload button at home",
      description: "Tick to enable reload function at home",
      defaultValue: false);
}
