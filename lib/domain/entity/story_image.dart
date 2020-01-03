import 'package:json_annotation/json_annotation.dart';

part 'story_image.g.dart';

@JsonSerializable()
class StoryImage {
  String filePath;
  String time;

  StoryImage({this.filePath, this.time = "Just now"});

  factory StoryImage.fromJson(Map<String, dynamic> json) =>
      _$StoryImageFromJson(json);

  Map<String, dynamic> toJson() => _$StoryImageToJson(this);
}
