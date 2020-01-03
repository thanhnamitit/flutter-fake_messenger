import 'package:conversation_maker/domain/entity/story_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class Story {
  @JsonKey(ignore: true)
  int id;
  DateTime createAt;
  String avatar;
  List<StoryImage> images;
  String name;
  @JsonKey(defaultValue: false)
  bool seen;

  Story({
    this.id,
    this.avatar,
    this.name,
    this.images,
    this.createAt,
    this.seen,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
