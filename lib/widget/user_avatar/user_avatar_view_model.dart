import 'package:conversation_maker/domain/usecase/get_user_avatar.dart';
import 'package:flutter/foundation.dart';

class UserAvatarViewModel with ChangeNotifier {
  final UserAvatarMgn avatarMgn;

  UserAvatarViewModel(this.avatarMgn);

  String get avatar => avatarMgn.avatar;

  set avatar(value) {
    avatarMgn.avatar = value;
    notifyListeners();
  }
}
