import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/domain/repository/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

class RepositoryImpl implements Repository {
  static const _CONVERSATION_STORE_NAME = "conversations";
  static const _MESSAGE_STORE_NAME = "messages";
  static const _STORY_STORE = "stories";
  final _conversationStore = intMapStoreFactory.store(_CONVERSATION_STORE_NAME);
  final _messageStore = intMapStoreFactory.store(_MESSAGE_STORE_NAME);
  final _storyStore = intMapStoreFactory.store(_STORY_STORE);

  BehaviorSubject<bool> storyStoreTriggerPublisher = BehaviorSubject()
    ..add(true);

  Observable<List<Story>> _storiesPublishSubject;

  Future<Database> _db;

  RepositoryImpl(this._db) {
    _storiesPublishSubject = storyStoreTriggerPublisher.concatMap((_) async* {
      yield await _getAllStories();
    });
  }

  @override
  Future deleteConversation(Conversation conversation) async {
    _conversationStore.delete(await _db,
        finder: Finder(
          filter: Filter.byKey(conversation.id),
        ));
    _messageStore.delete(await _db,
        finder: Finder(
          filter: Filter.equals("conversationId", conversation.id),
        ));
  }

  @override
  Future deleteMessage(Message message) async {
    _messageStore.delete(await _db,
        finder: Finder(filter: Filter.byKey(message.id)));
  }

  @override
  Future<List<Conversation>> getAllConversations() async {
    final finder = Finder(sortOrders: [
      SortOrder('lastTimeUpdated', false),
    ]);

    final recordSnapshots = await _conversationStore.find(
      await _db,
      finder: finder,
    );

    var conversations = recordSnapshots.map((snapshot) {
      final conversation = Conversation.fromJson(snapshot.value);
      conversation.id = snapshot.key;
      return conversation;
    }).toList();
    for (int i = 0; i < conversations.length; i++) {
      Conversation conversation = conversations[i];
      var lastMessageJson = (await _messageStore.findFirst(await _db,
              finder: Finder(
                  sortOrders: [SortOrder("time", false)],
                  filter: Filter.equals("conversationId", conversation.id))))
          ?.value;
      if (lastMessageJson != null) {
        Message lastMessage = Message.fromJson(lastMessageJson);
        conversation.lastMessage = lastMessage;
      }
    }
    return conversations;
  }

  @override
  Future updateConversation(Conversation newConversation) async {
    print(newConversation.toJson());

    _conversationStore.update(
      await _db,
      newConversation.toJson(),
      finder: Finder(filter: Filter.byKey(newConversation.id)),
    );
  }

  @override
  Future updateMessage(Message message) async {
    _messageStore.update(
      await _db,
      message.toJson(),
      finder: Finder(filter: Filter.byKey(message.id)),
    );
  }

  @override
  Future<int> insertConversation(Conversation conversation) async {
    return await _conversationStore.add(await _db, conversation.toJson());
  }

  @override
  Future<int> insertMessage(Message message) async {
    return await _messageStore.add(await _db, message.toJson());
  }

  @override
  Future<List<Message>> getAllMessagesOfConversation(int id) async {
    final finder = Finder(sortOrders: [
      SortOrder('time', false),
    ], filter: Filter.equals("conversationId", id));

    print(finder);
    final recordSnapshots = await _messageStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final conversation = Message.fromJson(snapshot.value);
      conversation.id = snapshot.key;
      return conversation;
    }).toList();
  }

  @override
  Future deleteStory(Story story) async {
    return null;
  }

  @override
  Future insertStory(Story story) async {
    await _storyStore.add(await _db, story.toJson());
    _onStoryStoreTrigger();
  }

  @override
  Stream<List<Story>> getAllStories() {
    return _storiesPublishSubject;
  }

  @override
  Future updateStory(Story story) async {
    _onStoryStoreTrigger();
  }

  void _onStoryStoreTrigger() {
    storyStoreTriggerPublisher.add(true);
  }

  Future<List<Story>> _getAllStories() async {
    final finder = Finder(sortOrders: [
      SortOrder('createAt', false),
    ]);

    final recordSnapshots = await _storyStore.find(await _db, finder: finder);

    return recordSnapshots.map((snapshot) {
      final story = Story.fromJson(snapshot.value);
      story.id = snapshot.key;
      return story;
    }).toList();
  }
}
