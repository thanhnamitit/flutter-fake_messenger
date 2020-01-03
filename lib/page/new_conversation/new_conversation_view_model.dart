import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/domain/entity/story_image.dart';
import 'package:conversation_maker/domain/usecase/create_story.dart';
import 'package:conversation_maker/domain/usecase/home/create_conversation.dart';
import 'package:flutter/foundation.dart';

class NewConversationViewModel with ChangeNotifier {
  final CreateConversation _createConversation;
  final CreateStory _createStory;

  NewConversationViewModel(
    this._createConversation,
    this._createStory,
  );

  Conversation conversation = Conversation.empty();

  void updateAvatar(String path) {
    this.conversation.avatar = path;
    notifyListeners();
  }

  Future<Conversation> saveConversation(String name) async {
    final timeNow = DateTime.now();
    Conversation conversation = this.conversation
      ..name = name
      ..lastTimeUpdated = timeNow
      ..createAt = timeNow
      ..lastMessage = MessageFactory.green(1);
    await _createConversation.execute(conversation);
    final story = Story(
      avatar: conversation.avatar,
      name: conversation.name,
      createAt: timeNow,
      seen: false,
      images: [
        StoryImage(
          filePath: conversation.avatar,
        )
      ],
    );
    await _createStory.execute(story);
    return conversation;
  }
}
