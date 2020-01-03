import 'package:conversation_maker/domain/entity/message.dart';

class MessageFactory {
  static Message _build(
    String content,
    int conversationId,
    MessageType type,
  ) {
    return Message()
      ..id = 1
      ..isMine = true
      ..removed = false
      ..status = MessageStatus.nothing
      ..time = DateTime.now()
      ..content = content
      ..conversationId = conversationId
      ..type = type;
  }

  static Message text(String content, int conversationId) =>
      _build(content, conversationId, MessageType.text);

  static Message emoji(String path, int conversationId) =>
      _build(path, conversationId, MessageType.emoji);

  static Message sticker(String path, int conversationId) =>
      _build(path, conversationId, MessageType.sticker);

  static Message green(int conversationId) =>
      _build("", conversationId, MessageType.green);

  static Message emojiPreview() => _build("", 0, MessageType.emojiPreview);

  static Message image(String filePath) =>
      _build(filePath, 0, MessageType.image);
}
