import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class CreateStory {
  Repository _repository;

  CreateStory(this._repository);

  Future execute(Story story) async {
    print("inserting: ${story.toJson()}");
    await _repository.insertStory(story);
  }
}
