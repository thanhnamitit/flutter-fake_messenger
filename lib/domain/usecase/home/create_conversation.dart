import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class CreateConversation {
  Repository _repository;

  CreateConversation(this._repository);

  Future execute(Conversation conversation) async {
    conversation.id = await _repository.insertConversation(conversation);
    final greenMessage = MessageFactory.green(conversation.id);
    conversation.lastMessage = greenMessage;
    greenMessage.id = await _repository.insertMessage(greenMessage);
  }
}
