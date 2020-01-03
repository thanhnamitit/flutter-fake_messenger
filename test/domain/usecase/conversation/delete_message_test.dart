import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/conversation/delete_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock.dart';

void main() {
  DeleteMessage deleteMessage;
  Repository repository;
  setUp(() {
    repository = MockRepository();
    deleteMessage = DeleteMessage(repository);
  });
  Message message = MessageFactory.text("hello", 1);
  test("should call repository.deleteMessage", () async {
    await deleteMessage.execute(message);
    verify(repository.deleteMessage(message));
  });
}
