import 'package:conversation_maker/core/util/image_utils.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation {
  @JsonKey(ignore: true)
  int id;
  String name;
  String avatar;
  String status;
  int color;
  bool blocked;
  bool isActive;
  String firstLineContent;
  String secondLineContent;
  DateTime createAt;
  DateTime lastTimeUpdated;
  int type;
  bool isGroup;
  String emoji;
  @JsonKey(ignore: true)
  Message lastMessage;

  Conversation(
      {this.id,
      this.name,
      this.avatar,
      this.status,
      this.color,
      this.blocked,
      this.isActive,
      this.firstLineContent,
      this.secondLineContent,
      this.createAt,
      this.lastTimeUpdated,
      this.type,
      this.isGroup,
      this.emoji,
      this.lastMessage});

  Conversation get clone => Conversation.fromJson(this.toJson())..id = this.id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Conversation &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          avatar == other.avatar &&
          status == other.status &&
          color == other.color &&
          blocked == other.blocked &&
          isActive == other.isActive &&
          firstLineContent == other.firstLineContent &&
          secondLineContent == other.secondLineContent &&
          createAt == other.createAt &&
          lastTimeUpdated == other.lastTimeUpdated &&
          type == other.type &&
          isGroup == other.isGroup &&
          emoji == other.emoji &&
          lastMessage == other.lastMessage;

  @override
  int get hashCode =>
      name.hashCode ^
      avatar.hashCode ^
      status.hashCode ^
      color.hashCode ^
      blocked.hashCode ^
      isActive.hashCode ^
      firstLineContent.hashCode ^
      secondLineContent.hashCode ^
      createAt.hashCode ^
      lastTimeUpdated.hashCode ^
      type.hashCode ^
      isGroup.hashCode ^
      emoji.hashCode ^
      lastMessage.hashCode;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  factory Conversation.empty() {
    return Conversation()
      ..name = ""
      ..avatar = null
      ..status = "Active now"
      ..color = R.color.defaultConversationColor.value
      ..blocked = false
      ..isActive = true
      ..firstLineContent = "You're friends on Facebook"
      ..secondLineContent = "Lives in UK"
      ..isGroup = false
      ..emoji = EmojiUtils.defaultOne;
  }

  @override
  String toString() {
    return 'Conversation{id: $id, name: $name, avatar: $avatar, status: $status, color: $color, blocked: $blocked, isActive: $isActive, firstLineContent: $firstLineContent, secondLineContent: $secondLineContent, createAt: $createAt, lastTimeUpdated: $lastTimeUpdated, type: $type, isGroup: $isGroup, emoji: $emoji, lastMessage: $lastMessage}';
  }
}
