import 'package:conversation_maker/core/base/base_view_model.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/domain/usecase/get_all_stories.dart';
import 'package:conversation_maker/domain/usecase/home/delete_conversation.dart';
import 'package:conversation_maker/domain/usecase/home/get_all_conversations.dart';
import 'package:conversation_maker/domain/usecase/update_conversatoin/update_conversation.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends BaseViewModel {
  static HomeViewModel of(BuildContext context) {
    return Provider.of<HomeViewModel>(context);
  }

  final GetAllConversations _getAllConversations;
  final DeleteConversation _deleteConversation;
  final UpdateConversation _updateConversation;
  final GetAllStories _getAllStories;

  List<Conversation> _conversations;
  List<Story> _stories;

  List<Conversation> get conversations {
    return _conversations;
  }

  List<Story> get stories {
    return _stories;
  }

  HomeViewModel(
    this._getAllConversations,
    this._deleteConversation,
    this._updateConversation,
    this._getAllStories,
  ) {
    loadAddConversations();
    _getAllStories.stream().execute(this, (stories) {
      onNewStoriesLoaded(stories);
    });
  }

  void onNewStoriesLoaded(List<Story> stories) {
    this._stories = stories;
    notifyListeners();
  }

  Future loadAddConversations() async {
    final conversations = await _getAllConversations.execute();
    this._conversations = conversations;
    print(conversations);
    notifyListeners();
  }

  void newConversationJustAdded(Conversation conversation) {
    _conversations.insert(0, conversation);
  }

  void updateNewestConversation(Conversation conversation) {
    Conversation willBeRemoved =
        _conversations.firstWhere((it) => it.id == conversation.id);
    conversations.remove(willBeRemoved);
    conversations.insert(0, conversation);
    notifyListeners();
    _updateConversation.execute(conversation);
  }

  void deleteConversation(Conversation conversation) {
    _conversations.remove(conversation);
    _deleteConversation.execute(conversation);
  }
}
