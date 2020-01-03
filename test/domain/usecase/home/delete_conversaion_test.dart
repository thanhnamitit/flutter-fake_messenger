import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/home/delete_conversation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock.dart';

void main() {
  DeleteConversation deleteConversation;
  Repository repository;

  setUp(() {
    repository = MockRepository();
    deleteConversation = DeleteConversation(repository);
  });

  Conversation tConversation = Conversation()..id = 1;

  test("should call repository.deleteConversation", () async {
    when(repository.deleteConversation(any)).thenAnswer((_) async {});
    deleteConversation.execute(tConversation);
    verify(repository.deleteConversation(tConversation));
  });
}
