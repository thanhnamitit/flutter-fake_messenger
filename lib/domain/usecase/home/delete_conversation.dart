import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class DeleteConversation {
  Repository _repository;

  DeleteConversation(this._repository);

  Future execute(Conversation conversation) {
    return _repository.deleteConversation(conversation);
  }
}
