import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/entity/story.dart';

abstract class Repository {
  Future<List<Conversation>> getAllConversations();

  Future<List<Message>> getAllMessagesOfConversation(int id);

  Stream<List<Story>> getAllStories();

  Future<int> insertConversation(Conversation conversation);

  Future<int> insertMessage(Message message);

  Future updateMessage(Message message);

  Future updateConversation(Conversation newConversation);

  Future deleteMessage(Message message);

  Future deleteConversation(Conversation conversation);

  Future insertStory(Story story);

  Future updateStory(Story story);

  Future deleteStory(Story story);
}
