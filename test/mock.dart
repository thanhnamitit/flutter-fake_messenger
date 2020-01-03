import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:conversation_maker/domain/usecase/get_all_stories.dart';
import 'package:conversation_maker/domain/usecase/home/create_conversation.dart';
import 'package:conversation_maker/domain/usecase/home/delete_conversation.dart';
import 'package:conversation_maker/domain/usecase/home/get_all_conversations.dart';
import 'package:mockito/mockito.dart';

class MockRepository extends Mock implements Repository {}

class MockCreateConversation extends Mock implements CreateConversation {}

class MockDeleteConversation extends Mock implements DeleteConversation {}

class MockGetAllStories extends Mock implements GetAllStories {}

class MockGetAllConversation extends MockRepository
    implements GetAllConversations {}
