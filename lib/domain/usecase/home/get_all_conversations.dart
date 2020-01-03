import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';

class GetAllConversations {
  Repository _repository;

  GetAllConversations(this._repository);

  Future<List<Conversation>> execute() {
    return _repository.getAllConversations();
  }
}
