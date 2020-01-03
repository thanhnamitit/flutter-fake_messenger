import 'package:conversation_maker/core/fuctional/safe_list.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class GetAllMessage {
  Repository _repository;

  GetAllMessage(this._repository);

  Future<SafeList<Message>> execute(Conversation conversation) async {
    return SafeList()
      ..addAll(
          await _repository.getAllMessagesOfConversation(conversation.id));
  }
}
