import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class DeleteMessage {
  Repository _repository;

  DeleteMessage(this._repository);

  Future execute(
    Message message,
  ) {
    return _repository.deleteMessage(message);
  }
}
