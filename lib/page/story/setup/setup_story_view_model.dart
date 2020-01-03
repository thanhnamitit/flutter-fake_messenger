import 'package:conversation_maker/core/base/base_view_model.dart';
import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/domain/entity/story_image.dart';

class SetupStoryViewModel extends BaseViewModel {
  Story _story;

  Story get story => _story;

  SetupStoryViewModel(Story story) {
    this._story = story ??
        Story(
          images: [
            StoryImage(time: "Just now"),
            StoryImage(time: "Just now"),
          ],
          avatar: null,
          name: "No name",
          seen: false,
        );
  }

  void updateName(String newName) {
    _story.name = newName;
    notifyListeners();
  }

  void updateSeen(bool seen) {
    _story.seen = seen;
    notifyListeners();
  }

  void delete(StoryImage storyImage) {
    _story.images.remove(storyImage);
    notifyListeners();
  }
}
