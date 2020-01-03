import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/conversation/update_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock.dart';

void main() {
  UpdateMessage updateMessage;
  Repository repository;

  setUp(() {
    repository = MockRepository();
    updateMessage = UpdateMessage(repository);
  });

  Message message = MessageFactory.text("hi", 1);

  test("should call repository.updateMessage()", () async {
    await updateMessage.execute(message);
    verify(repository.updateMessage(message));
  });
}
