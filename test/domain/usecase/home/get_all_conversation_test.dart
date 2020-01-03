import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/home/get_all_conversations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock.dart';

main() {
  GetAllConversations getAllConversations;
  Repository repository;

  setUp(() {
    repository = MockRepository();
    getAllConversations = GetAllConversations(repository);
  });

  List<Conversation> tConversations =
      Iterable.generate(10).map((index) => Conversation()..id = index).toList();

  test("Should call repository.getAllConversation", () async {
    when(repository.getAllConversations()).thenAnswer(
      (_) async => tConversations,
    );
    final result = await getAllConversations.execute();
    expect(result, tConversations);
    verify(repository.getAllConversations());
  });
}
