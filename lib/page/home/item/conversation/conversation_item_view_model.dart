import 'package:conversation_maker/core/util/date_time_utils.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:intl/intl.dart';

class ConversationItemViewModel {
  final Conversation _conversation;

  ConversationItemViewModel(this._conversation);

  String get avatar => _conversation.avatar;

  Conversation get conversation => _conversation;

  int get id => _conversation.id;

  String get name => _conversation.name;

  String get lastMessageContent {
    var lastMessage = _conversation.lastMessage;
    var name = lastMessage?.name ?? _conversation.name;
    String result;
    if (lastMessage == null) {
      result = "hi";
    } else {
      switch (lastMessage.type) {
        case MessageType.image:
          result = "${lastMessage.isMine ? "You" : name} sent a photo";
          break;
        case MessageType.green:
          result = _getGreenMessage(name);
          break;
        case MessageType.sticker:
        case MessageType.emoji:
          result = "${lastMessage.isMine ? "You" : name} sent a sticker";
          break;
        default:
          result = "${lastMessage.isMine ? "You:" : ""} ${lastMessage.content}";
      }
    }
    return result;
  }

  String _getGreenMessage(String name) {
    return "Say hi to your new Facebook friend, ${_conversation.name}";
  }

  String get lastTime {
    String format;
    final time = _conversation.lastMessage.time;
    if (DateTimeUtils.isAfterFromNow(time, day: 1, hour: 12)) {
      format = "HH:mm";
    } else if (DateTimeUtils.isAfterFromNow(time, day: 7)) {
      format = "MMM dd";
    } else {
      format = "MMM";
    }
    return DateFormat(format).format(_conversation.lastMessage.time);
  }
}
