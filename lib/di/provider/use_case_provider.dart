import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/conversation/add_message.dart';
import 'package:conversation_maker/domain/usecase/conversation/delete_message.dart';
import 'package:conversation_maker/domain/usecase/conversation/get_all_message.dart';
import 'package:conversation_maker/domain/usecase/conversation/update_message.dart';
import 'package:conversation_maker/domain/usecase/create_story.dart';
import 'package:conversation_maker/domain/usecase/get_all_stories.dart';
import 'package:conversation_maker/domain/usecase/get_user_avatar.dart';
import 'package:conversation_maker/domain/usecase/home/create_conversation.dart';
import 'package:conversation_maker/domain/usecase/home/delete_conversation.dart';
import 'package:conversation_maker/domain/usecase/home/get_all_conversations.dart';
import 'package:conversation_maker/domain/usecase/update_conversatoin/update_conversation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseCaseProvider {
  final Repository _repository;
  final SharedPreferences _preferences;

  UseCaseProvider(this._repository, this._preferences);

  GetAllConversations get getAllConversationUseCase {
    return GetAllConversations(_repository);
  }

  DeleteConversation get deleteConversationUseCase {
    return DeleteConversation(_repository);
  }

  CreateConversation get createConversationUseCase {
    return CreateConversation(_repository);
  }

  CreateStory get createStoryUseCase {
    return CreateStory(_repository);
  }

  GetAllMessage get getAllMessageUseCase {
    return GetAllMessage(_repository);
  }

  AddMessage get addMessageUseCase {
    return AddMessage(_repository);
  }

  UpdateMessage get updateMessageUseCase {
    return UpdateMessage(_repository);
  }

  DeleteMessage get deleteMessageUseCase {
    return DeleteMessage(_repository);
  }

  UpdateConversation get updateConversationUseCase {
    return UpdateConversation(_repository);
  }

  UserAvatarMgn get userAvatarUseCase {
    return UserAvatarMgn(_preferences);
  }

  GetAllStories get getAllStoriesUseCase {
    return GetAllStories(_repository);
  }
}
