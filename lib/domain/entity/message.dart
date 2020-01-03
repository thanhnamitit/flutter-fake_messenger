import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

enum MessageType { text, image, audio, green, emoji, emojiPreview, sticker }
enum MessageStatus { nothing, sending, sent, delivered, failed, read }

@JsonSerializable()
class Message {
  @JsonKey(ignore: true)
  int id;

  int conversationId;

  String content;

  String name;

  String avatar;

  bool isMine;

  DateTime time;

  bool removed;

  MessageType type;

  MessageStatus status;

  Message({
    this.id,
    this.conversationId,
    this.content,
    this.name,
    this.avatar,
    this.isMine,
    this.time,
    this.removed,
    this.type,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          conversationId == other.conversationId &&
          content == other.content &&
          name == other.name &&
          avatar == other.avatar &&
          isMine == other.isMine &&
          time == other.time &&
          removed == other.removed &&
          type == other.type &&
          status == other.status;

  @override
  int get hashCode =>
      conversationId.hashCode ^
      content.hashCode ^
      name.hashCode ^
      avatar.hashCode ^
      isMine.hashCode ^
      time.hashCode ^
      removed.hashCode ^
      type.hashCode ^
      status.hashCode;

  Message get clone => Message.fromJson(this.toJson());

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
