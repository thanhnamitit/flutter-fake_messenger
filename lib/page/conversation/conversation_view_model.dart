import 'package:conversation_maker/core/base/base_view_model.dart';
import 'package:conversation_maker/core/fuctional/pair.dart';
import 'package:conversation_maker/core/fuctional/safe_list.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/usecase/conversation/add_message.dart';
import 'package:conversation_maker/domain/usecase/conversation/delete_message.dart';
import 'package:conversation_maker/domain/usecase/conversation/get_all_message.dart';
import 'package:conversation_maker/domain/usecase/conversation/update_message.dart';
import 'package:conversation_maker/domain/usecase/update_conversatoin/update_conversation.dart';
import 'package:conversation_maker/page/conversation/emoji_item_view_model.dart';
import 'package:rxdart/rxdart.dart';

import 'message_item_view_model.dart';

class ConversationViewModel extends BaseViewModel {
  Conversation _conversation;
  SafeList<Message> _messages;
  SafeList<MessageItemViewModel> messageViewModels;
  final GetAllMessage _getAllMessage;
  final AddMessage _addMessage;
  final UpdateMessage _updateMessage;
  final DeleteMessage _deleteMessage;
  final UpdateConversation _updateConversation;

  PublishSubject<int> messageAddedNotifier = PublishSubject();
  PublishSubject<Pair<int, MessageItemViewModel>> messageDeletedNotifier =
      PublishSubject();

  Conversation get conversation {
    return _messages != null
        ? (_conversation..lastMessage = _messages.first)
        : _conversation;
  }

  List<Message> get messages => _messages;

  ConversationViewModel(
      this._conversation,
      this._getAllMessage,
      this._addMessage,
      this._updateMessage,
      this._deleteMessage,
      this._updateConversation) {
    _loadConversation();
  }

  void _loadConversation() {
    _getAllMessage.execute(_conversation).then((it) {
      this._messages = it;
      genNewMessageViewModels();
    });
  }

  void genNewMessageViewModels() {
    messageViewModels = _mapMessagesToViewModels(_conversation, _messages);
    notifyListeners();
  }

  void addNewMessage(
    Message message, {
    bool saveToDatabase = true,
  }) {
    addItemMessageViewModelIfNeed(message);
    message.conversationId = conversation.id;
    _messages.addFirst(message);
    _notifyNearByMessagesChangedAfterAdded();
    if (saveToDatabase) {
      _addMessage.execute(message);
    }
  }

  void addItemMessageViewModelIfNeed(Message message) {
    final firstItemViewModel = messageViewModels.first;
    if (firstItemViewModel is EmojiItemViewModel &&
        firstItemViewModel.isPreview) {
      firstItemViewModel.transformToOfficial(message);
    } else {
      MessageItemViewModel itemViewModel = createItemViewModel(message);
      messageViewModels.addFirst(itemViewModel);
      messageAddedNotifier.add(0);
    }
  }

  void _notifyNearByMessagesChangedAfterAdded() {
    messageViewModels.first.nearByMessageChanged();
    messageViewModels.second.nearByMessageChanged();
  }

  void updateMessage(Message message) {
    int index = messages.indexOf(message);
    messageViewModels[index]?.nearByMessageChanged();
    messageViewModels[index - 1]?.nearByMessageChanged();
    messageViewModels[index + 1]?.nearByMessageChanged();
    _updateMessage.execute(message);
  }

  void deleteMessage(Message message) {
    int index = messages.indexOf(message);
    if (index != -1) {
      messages.remove(message);
      final viewModel = messageViewModels.removeAt(index);
      messageViewModels[index - 1]?.nearByMessageChanged();
      messageViewModels[index]?.nearByMessageChanged();
      messageDeletedNotifier.add(Pair(index, viewModel));
    }
    _deleteMessage.execute(message);
  }

  void addEmojiPreviewMessage() {
    messageViewModels.insert(
        0, createItemViewModel(MessageFactory.emojiPreview()));
    messageAddedNotifier.add(0);
  }

  void removeEmojiPreviewMessage() {
    final viewModel = messageViewModels[0];
    if (viewModel.message.type == MessageType.emojiPreview) {
      messageViewModels.removeAt(0);
      messageDeletedNotifier.add(Pair(0, viewModel));
    }
  }

  void emojiSizeChange(double size) {
    (messageViewModels.where((it) => it is EmojiItemViewModel).first
            as EmojiItemViewModel)
        ?.onSizeChange(size: size);
  }

  void updateConversation(Conversation updatedConversation) {
    print("update ne");
    this._conversation = updatedConversation;
    genNewMessageViewModels();
    _updateConversation.execute(updatedConversation);
  }

  SafeList<MessageItemViewModel> _mapMessagesToViewModels(
      Conversation conversation, SafeList<Message> messages,
      {bool justAddedNewMessage = false}) {
    List<MessageItemViewModel> result = [];
    for (int i = 0; i < messages.length; i++) {
      Message before = messages.before(index: i);
      Message after = messages.after(index: i);
      final middle = messages[i];
      final itemViewModel = middle.type == MessageType.emoji
          ? EmojiItemViewModel.analyze(
              conversation, before, middle, after, messages)
          : MessageItemViewModel.analyze(
              conversation, before, middle, after, messages);
      result.add(itemViewModel);
    }
    return SafeList()..addAll(result);
  }

  MessageItemViewModel createItemViewModel(Message message) {
    MessageItemViewModel result;
    if (message.type == MessageType.emoji) {
      result = EmojiItemViewModel.normal(conversation, _messages, message);
    } else if (message.type == MessageType.emojiPreview) {
      result = EmojiItemViewModel.preview(conversation, _messages, message);
    } else {
      result = MessageItemViewModel(conversation, messages, message);
    }
    return result;
  }
}
