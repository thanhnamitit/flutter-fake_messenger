import 'package:conversation_maker/core/fuctional/safe_list.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/conversation/get_all_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock.dart';

void main() {
  GetAllMessage getAllMessage;
  Repository repository;
  setUp(() {
    repository = MockRepository();
    getAllMessage = GetAllMessage(repository);
  });
  List<Message> messages = Iterable.generate(10)
      .map((index) => MessageFactory.text("Index $index", 6626))
      .toList();

  group("Test get all message", () {
    Conversation mockConversation = Conversation()..id = 1;
    void setupRepository() {
      when(repository.getAllMessagesOfConversation(any))
          .thenAnswer((_) async => messages);
    }

    test("Should call repository.LoadAllMessageOfConversation ", () async {
      setupRepository();
      await getAllMessage.execute(mockConversation);
      verify(repository.getAllMessagesOfConversation(mockConversation.id));
    });

    test("Respose is safe list", () async {
      setupRepository();
      final list = await getAllMessage.execute(mockConversation);
      expect(list, isA<SafeList>());
      expect(list.length, 10);
      expect(list[-1], null);
    });
  });
}
