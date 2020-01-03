import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class GetAllStories {
  final Repository repository;

  GetAllStories(this.repository);

  Stream<List<Story>> stream() {
    return repository.getAllStories();
  }
}
