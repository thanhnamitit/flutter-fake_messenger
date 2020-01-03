import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class UpdateConversation {
  Repository _repository;

  UpdateConversation(this._repository);

  Future execute(Conversation conversation) {
    conversation.lastTimeUpdated = DateTime.now();
    return _repository.updateConversation(conversation);
  }
}
