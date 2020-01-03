import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class UpdateMessage {
  Repository _repository;

  UpdateMessage(this._repository);

  Future execute(Message message) {
    return _repository.updateMessage(message);
  }
}
