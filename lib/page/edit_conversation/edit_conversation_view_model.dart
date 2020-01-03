import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:flutter/foundation.dart';

class EditConversationViewModel with ChangeNotifier {
  final Conversation _conversation;
  Conversation _temp;

  Conversation get conversation {
    return _temp;
  }

  bool get hasChanged {
    return _conversation != _temp;
  }

  EditConversationViewModel(this._conversation) {
    this._temp = _conversation;
  }

  void updateConversation(Conversation conversation) {
    this._temp = conversation;
    notifyListeners();
  }
}
