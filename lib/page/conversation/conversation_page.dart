import 'package:conversation_maker/core/route_config.dart';
import 'package:conversation_maker/core/constant/constant.dart';
import 'package:conversation_maker/di/provider/view_model_provider.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/page/conversation/conversation_view_model.dart';
import 'package:conversation_maker/page/conversation/page_children/conversation_input_widget.dart';
import 'package:conversation_maker/widget/avatar.dart';
import 'package:conversation_maker/widget/item/message/message_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message_item_view_model.dart';

class ConversationPage extends StatefulWidget {
  final Conversation _conversation;

  ConversationPage(this._conversation);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  void _openEditPage(
    BuildContext context,
    Conversation currentConversation,
  ) async {
    var updatedConversation = await Navigator.of(context).pushNamed(
        RouteConfig.ROUTE_EDIT_CONVERSATION,
        arguments: currentConversation);
    if (updatedConversation != null) {
      print("Received data: ${(updatedConversation as Conversation).toJson()}");

      Provider.of<ConversationViewModel>(context)
          .updateConversation(updatedConversation);
    }
  }

  void _passBackConversation(Conversation conversation) {
    // print("Converastion pass to home: $conversation");
    Navigator.of(context).pop(conversation);
  }

  Widget _buildAppBar() {
    return AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Consumer<ConversationViewModel>(
          builder: (context, viewModel, __) {
            Conversation conversation = viewModel.conversation;
            var conversationColor = Color(conversation.color);
            return Row(
              children: <Widget>[
                SizedBox(
                  width: 4,
                ),
                InkWell(
                  onTap: () {
                    _passBackConversation(conversation);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.arrow_back,
                      color: conversationColor,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      _openEditPage(context, conversation);
                    },
                    child: Row(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Hero(
                              tag: "avatar${widget._conversation.id}",
                              child: MessageCircleAvatar(conversation.avatar),
                            ),
                            Visibility(
                              visible: conversation.isActive &&
                                  !conversation.blocked,
                              child: Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                      shape: BoxShape.circle,
                                      color: SpecialColors
                                          .FACEBOOK_ACTIVE_STATUS_COLOR),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                conversation.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Visibility(
                                maintainSize: false,
                                visible: !conversation.blocked &&
                                    conversation.status.isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    conversation.status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !conversation.blocked,
                  maintainSize: false,
                  child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {},
                      child: Icon(Icons.call, color: conversationColor)),
                ),
                SizedBox(
                  width: 12,
                ),
                Visibility(
                  visible: !conversation.blocked,
                  maintainSize: false,
                  child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {},
                      child: Icon(Icons.videocam, color: conversationColor)),
                ),
                Visibility(
                  visible: conversation.isActive && !conversation.blocked,
                  maintainState: false,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: SpecialColors.FACEBOOK_ACTIVE_STATUS_COLOR),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {},
                    child: Icon(Icons.info, color: conversationColor)),
                SizedBox(
                  width: 12,
                ),
              ],
            );
          },
        ));
  }

  Widget _buildLoadingProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildConversationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: MessageList()),
        ConversationInput(),
      ],
    );
  }

  Widget _buildPageBody() {
    return Consumer<ConversationViewModel>(
      builder: (_, viewModel, __) {
        return viewModel.messages == null
            ? _buildLoadingProgressIndicator()
            : _buildConversationContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModelProvider.of(context)
        .conversationViewModel(widget._conversation);
    return ChangeNotifierProvider(
      builder: (_) => viewModel,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(viewModel.conversation);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          appBar: _buildAppBar(),
          body: SafeArea(child: _buildPageBody()),
        ),
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  MessageList();

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ConversationViewModel _viewModel;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _onMessageAdded(int index) {
    _listKey.currentState.insertItem(0, duration: Duration(milliseconds: 500));
  }

  void _onMessageDeleted(int index, MessageItemViewModel viewModel) {
    _listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity:
              CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
          child: SizeTransition(
              sizeFactor:
                  CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
              axisAlignment: 0.0,
              child: _buildMessageItem(viewModel)),
        );
      },
      duration: Duration(milliseconds: 300),
    );
  }

  void _setupMessagesListener() {
    _viewModel?.messageAddedNotifier?.listen(_onMessageAdded);
    _viewModel?.messageDeletedNotifier
        ?.listen((it) => _onMessageDeleted(it.left, it.right));
  }

  void _cancelMessagesListener() {
    _viewModel?.messageAddedNotifier?.close();
    _viewModel?.messageDeletedNotifier?.close();
  }

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ConversationViewModel>(context, listen: false);
    _setupMessagesListener();
  }

  @override
  void dispose() {
    _cancelMessagesListener();
    super.dispose();
  }

  Widget _buildMessageItem(MessageItemViewModel viewModel) {
    return MessageItem(
      viewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationViewModel>(
      builder: (_, viewModel, __) {
        print("Build here");
        final messageViewModels = viewModel.messageViewModels;
        return AnimatedList(
          key: _listKey,
          padding: EdgeInsets.symmetric(vertical: 12),
          reverse: true,
          initialItemCount: messageViewModels.length,
          itemBuilder: (_, index, animation) {
            return FadeTransition(
              key: ObjectKey(messageViewModels[index]),
              opacity: animation,
              child: SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: animation,
                  curve: Interval(0.0, 1.0),
                ),
                axisAlignment: 0.0,
                child: _buildMessageItem(
                  messageViewModels[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
