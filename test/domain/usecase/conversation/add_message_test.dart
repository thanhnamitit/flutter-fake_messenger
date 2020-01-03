import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/conversation/add_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock.dart';


void main() {
  AddMessage addMessage;
  MockRepository repository;

  setUp(() {
    repository = MockRepository();
    addMessage = AddMessage(repository);
  });

  Message message = MessageFactory.text("aloxo", 1);
  int id = 6626;

  test("should update message id after add to database", () async {
    when(repository.insertMessage(any)).thenAnswer((_) async => id);

    await addMessage.execute(message);

    verify(repository.insertMessage(message));
    expect(message.id, id);
  });
}
