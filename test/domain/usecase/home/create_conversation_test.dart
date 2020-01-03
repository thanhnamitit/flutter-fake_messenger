import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/home/create_conversation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock.dart';

void main() {
  CreateConversation createConversation;
  Repository repository;
  setUp(() {
    repository = MockRepository();
    createConversation = CreateConversation(repository);
  });

  Conversation tConversation = Conversation();
  int tConversationId = 6626;
  int tMessageId = 123;

  group("Create conversation group test", () {
    void setupRepository() {
      when(repository.insertConversation(tConversation))
          .thenAnswer((_) async => tConversationId);

      when(repository.insertMessage(any)).thenAnswer((_) async => tMessageId);
    }

    test("Should call enough function in repository", () async {
      setupRepository();
      await createConversation.execute(tConversation);
      verify(repository.insertConversation(tConversation));
      verify(repository.insertMessage(any));
      expect(tConversation.lastMessage.conversationId, tConversationId);
      expect(tConversation.lastMessage.id, tMessageId);
      expect(tConversation.id, tConversationId);
    });
  });
}
