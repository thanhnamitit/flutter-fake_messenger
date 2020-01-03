import 'package:conversation_maker/core/fuctional/safe_list.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItemViewModel with ChangeNotifier {
  Message _message;
  final Conversation _conversation;
  final SafeList<Message> _messages;
  bool topBorder;
  bool bottomBorder;
  bool showAvatar;

  MessageItemViewModel(
    this._conversation,
    this._messages,
    this._message,
  );

  void updateMessage(Message message) {
    this._message = message;
  }

  void analyze(Message center, Message before, Message after) {
    if (before != null &&
        (before.isMine != center.isMine ||
            before.status == MessageStatus.failed)) before = null;
    if (after != null &&
        (after.isMine != center.isMine ||
            after.status == MessageStatus.failed ||
            after.type == MessageType.green)) after = null;
    bottomBorder = before == null || center.status == MessageStatus.failed;
    topBorder = after == null || center.status == MessageStatus.failed;
    showAvatar = before == null && !center.isMine;
  }

  void nearByMessageChanged() {
    int index = _messages.indexOf(_message);
    if (index != -1) {
      analyze(
        message,
        _messages.before(model: message),
        _messages.after(model: message),
      );
      notifyListeners();
    }
  }

  Conversation get conversation => _conversation;

  String get avatarUrl => _conversation.avatar;

  Color get conversationColor => Color(_conversation.color);

  factory MessageItemViewModel.analyze(
    Conversation conversation,
    Message before,
    Message center,
    Message after,
    SafeList<Message> messages,
  ) {
    return MessageItemViewModel(conversation, messages, center)
      ..analyze(center, before, after);
  }

  factory MessageItemViewModel.likePreview(
      Conversation conversation, Message message) {
    return MessageItemViewModel(conversation, null, message);
  }

  String get rootContent => _message.content;

  String get messageContent => !_message.removed
      ? _message.content
      : _message.isMine
          ? "You removed a message"
          : "${_conversation.name} removed a message";

  get showFailMessage =>
      _message.status == MessageStatus.failed && !_message.removed;

  get isFailMessage => _message.status == MessageStatus.failed;

  String get avatarFilePath => _conversation.avatar;

  bool get isMine => _message.isMine;

  MessageStatus get status => _message.status;

  bool get removed => _message.removed;

  Message get message => _message;

  MessageType get type => _message.type;

  Message get toggleIsMineFlagMessage => _message
    ..isMine = !_message.isMine
    ..status = MessageStatus.nothing;

  Message get toggleRemovedFlagMessage => _message
    ..removed = !_message.removed
    ..status = MessageStatus.nothing;

  String get conversationName => _conversation.name;

  bool get conversationIsActive => _conversation.isActive;

  String get conversationContentBellowName => "You're friends on Facebook";

  String get conversationFirstLineContent => _conversation.firstLineContent;

  String get conversationSecondLineContent => _conversation.secondLineContent;

  String get createTime => DateFormat("MMM dd AT hh:mm").format(message.time);

  String get greenBellowCoupleAvatarsContent =>
      "Say hi to your new facebook friend, ${_conversation.name.split(' ').first}";

  String get greenWithAWaveContent =>
      "Say hi to ${_conversation.name} with a wave.";

  MessageType get messageType => _message.type;

  String get emoji => _conversation.emoji;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageItemViewModel &&
          runtimeType == other.runtimeType &&
          _message == other._message &&
          _conversation == other._conversation;

  @override
  int get hashCode => _message.hashCode ^ _conversation.hashCode;
}
