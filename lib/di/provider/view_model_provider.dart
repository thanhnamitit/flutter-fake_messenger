import 'package:conversation_maker/di/provider/use_case_provider.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/page/conversation/conversation_view_model.dart';
import 'package:conversation_maker/page/edit_conversation/edit_conversation_view_model.dart';
import 'package:conversation_maker/page/home/home_view_model.dart';
import 'package:conversation_maker/page/new_conversation/new_conversation_view_model.dart';
import 'package:conversation_maker/page/story/setup/setup_story_view_model.dart';
import 'package:conversation_maker/widget/user_avatar/user_avatar_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ViewModelProvider {
  static ViewModelProvider of(BuildContext context) =>
      Provider.of<ViewModelProvider>(context);

  final UseCaseProvider _useCaseProvider;

  ViewModelProvider(this._useCaseProvider);

  HomeViewModel homeViewModel() {
    return HomeViewModel(
      _useCaseProvider.getAllConversationUseCase,
      _useCaseProvider.deleteConversationUseCase,
      _useCaseProvider.updateConversationUseCase,
      _useCaseProvider.getAllStoriesUseCase,
    );
  }

  ConversationViewModel conversationViewModel(Conversation conversation) {
    return ConversationViewModel(
        conversation,
        _useCaseProvider.getAllMessageUseCase,
        _useCaseProvider.addMessageUseCase,
        _useCaseProvider.updateMessageUseCase,
        _useCaseProvider.deleteMessageUseCase,
        _useCaseProvider.updateConversationUseCase);
  }

  EditConversationViewModel editConversationViewModel(
      Conversation conversation) {
    return EditConversationViewModel(conversation);
  }

  UserAvatarViewModel userAvatarViewModel() {
    return UserAvatarViewModel(_useCaseProvider.userAvatarUseCase);
  }

  NewConversationViewModel newConversationViewModel() {
    return NewConversationViewModel(
      _useCaseProvider.createConversationUseCase,
      _useCaseProvider.createStoryUseCase,
    );
  }

  SetupStoryViewModel setupStoryViewModel(Story story) {
    return SetupStoryViewModel(story);
  }
}
