import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/repository/repository.dart';

class AddMessage {
  Repository _repository;

  AddMessage(this._repository);

  Future execute(
    Message message,
  ) async {
    message.id = await _repository.insertMessage(message);
  }
}
