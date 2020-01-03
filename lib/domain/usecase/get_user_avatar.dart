import 'package:shared_preferences/shared_preferences.dart';

class UserAvatarMgn {
  static const KEY = "key_user_avatar";

  final SharedPreferences preferences;

  UserAvatarMgn(this.preferences);

  String get avatar => preferences.getString(KEY);

  set avatar(value) => preferences.setString(KEY, value);
}
