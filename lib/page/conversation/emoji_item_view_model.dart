import 'dart:math';

import 'package:conversation_maker/core/fuctional/safe_list.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/page/conversation/message_item_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

Random rd = Random();

class EmojiItemViewModel extends MessageItemViewModel {
  PublishSubject<bool> messageTransformedNotifier = PublishSubject();

  double size = 1;
  double _angel = 0;

  double get finalSize {
    List<String> emojiInfo = message.content.split("-");
    return double.parse(emojiInfo[1]);
  }

  String get asset => conversation.emoji;

  double get angel {
    return _angel;
  }

  bool get isPreview => message.type == MessageType.emojiPreview;

  EmojiItemViewModel._(
      Conversation conversation, SafeList<Message> messages, Message message)
      : super(conversation, messages, message);

  @override
  void analyze(Message center, Message before, Message after) {
    super.analyze(center, before, after);
    size = finalSize;
  }

  factory EmojiItemViewModel.normal(
      Conversation conversation, SafeList<Message> messages, Message message) {
    final result = EmojiItemViewModel._(conversation, messages, message);
    result.size = result.finalSize;
    return result;
  }

  factory EmojiItemViewModel.analyze(
    Conversation conversation,
    Message before,
    Message center,
    Message after,
    SafeList<Message> messages,
  ) {
    return EmojiItemViewModel._(conversation, messages, center)
      ..analyze(center, before, after);
  }

  factory EmojiItemViewModel.preview(
      Conversation conversation, SafeList<Message> messages, Message message) {
    return EmojiItemViewModel._(conversation, messages, message);
  }

  void transformToOfficial(Message message) {
    updateMessage(message);
    messageTransformedNotifier.add(true);
  }

  void onSizeChange({
    @required double size,
    double angel,
  }) {
    if (type == MessageType.emojiPreview || type == MessageType.emoji) {
      if (angel == null) {
        angel = pi * 2 + (rd.nextBool() ? size : -size) / 50;
      }
      this.size = size;
      this._angel = angel;
      notifyListeners();
    }
  }
}
