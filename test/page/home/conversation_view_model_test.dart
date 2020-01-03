import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/usecase/get_all_stories.dart';
import 'package:conversation_maker/domain/usecase/home/delete_conversation.dart';
import 'package:conversation_maker/domain/usecase/home/get_all_conversations.dart';
import 'package:conversation_maker/domain/usecase/update_conversatoin/update_conversation.dart';
import 'package:conversation_maker/page/home/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mock.dart';

main() {
  GetAllConversations getAllConversations;
  DeleteConversation deleteConversation;
  UpdateConversation updateConversation;
  GetAllStories getAllStories;
  HomeViewModel viewModel;
  setUp(() {
    getAllConversations = MockGetAllConversation();
    deleteConversation = MockDeleteConversation();
  });

  List<Conversation> tConversations =
      Iterable.generate(10).map((index) => Conversation()..id = index).toList();

  group("test home view model", () {
    void setupUseCase() {
      when(getAllConversations.execute())
          .thenAnswer((_) async => tConversations);
      when(deleteConversation.execute(any)).thenAnswer((_) async => {});
    }

    test("should get all viewmodel after init", () async {
      setupUseCase();
      viewModel = HomeViewModel(getAllConversations, deleteConversation,
          updateConversation, getAllStories);
      verify(getAllConversations.execute());
      await Future.delayed(const Duration(milliseconds: 500), () {});
      expect(viewModel.conversations, tConversations);
      expect(viewModel.conversations.length, 10);
    });

    test("Should call notifyListener after delete", () async {
      setupUseCase();
      viewModel = HomeViewModel(getAllConversations, deleteConversation,
          updateConversation, getAllStories);
      await Future.delayed(const Duration(milliseconds: 500), () {});
      final firstConversation = tConversations.first;
      viewModel.deleteConversation(firstConversation);
      verify(deleteConversation.execute(firstConversation));
      expect(tConversations.length, 9);
    });
  });
}
