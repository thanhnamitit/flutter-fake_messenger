import 'dart:ui';

import 'package:conversation_maker/core/helper/UIHelpers.dart';
import 'package:conversation_maker/core/route_config.dart';
import 'package:conversation_maker/di/provider/view_model_provider.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/feature/feature.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:conversation_maker/widget/item/story/self_story_item.dart';
import 'package:conversation_maker/widget/item/story/story_item.dart';
import 'package:conversation_maker/widget/user_avatar/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'home_view_model.dart';
import 'item/conversation/conversation_item.dart';
import 'item/conversation/conversation_item_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _onConversationSelected(
      BuildContext context, Conversation conversation) async {
    print(conversation.toJson());
    print(conversation.id);
    var newestConversation = await Navigator.of(context).pushNamed(
        RouteConfig.ROUTE_CONVERSATION,
        arguments: conversation.clone);
    if (conversation != newestConversation) {
      HomeViewModel.of(context).updateNewestConversation(newestConversation);
    }
  }

  void _createNewConversation(BuildContext context) async {
    var conversation = await Navigator.of(context)
        .pushNamed(RouteConfig.ROUTE_NEW_CONVERSATION);
    if (conversation != null) {
      print(conversation);
      _addConversation(context, conversation);
    }
  }

  Widget _buildActionButton(IconData iconData, Color backgroundColor,
      {Color iconColor = Colors.black, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Icon(
          iconData,
          color: iconColor,
          size: 22,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (_, viewModel, __) {
        var conversations = viewModel.conversations;
        if (conversations == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSearchBar(context),
              verticalSpaceLarge,
              _buildStoriesList(viewModel),
              _buildConversationsList(viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext buildContext) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: R.color.homeGrey,
        borderRadius: BorderRadius.all(Radius.circular(48)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            color: Colors.grey,
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.w500),
              autofocus: false,
              decoration: InputDecoration(
                focusColor: Colors.transparent,
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _createNewStory() {
//    Navigator.of(context).pushNamed(RouteConfig.ROUTE_SETUP_STORY);
  }

  void _openStory() {}

  Widget _buildStoriesList(HomeViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelfStoryItem(
            onTap: () {
              _createNewStory();
            },
          ),
        ]..addAll(
            viewModel.stories?.map((it) => StoryItem(it))?.toList() ?? [],
          ),
      ),
    );
  }

  void _deleteConversation(
      BuildContext context, Conversation conversation, int index) {
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
            child: _buildConversationItem(
              conversation,
              index,
              forDelete: true,
            ),
          ),
        );
      },
      duration: Duration(milliseconds: 300),
    );
    Provider.of<HomeViewModel>(context).deleteConversation(conversation);
  }

  void _addConversation(BuildContext context, Conversation conversation) {
    Provider.of<HomeViewModel>(context).newConversationJustAdded(conversation);
    _listKey.currentState.insertItem(0, duration: Duration(milliseconds: 500));
  }

  Widget _buildConversationItem(
    Conversation conversation,
    int index, {
    HomeViewModel viewModel,
    BuildContext context,
    bool forDelete = false,
  }) {
    return Visibility(
      visible: !forDelete,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Slidable(
        key: ObjectKey(conversation),
        child: ConversationItem(ConversationItemViewModel(conversation), (it) {
          _onConversationSelected(context, it);
        }),
        actionPane: SlidableScrollActionPane(),
        actionExtentRatio: .5,
        closeOnScroll: true,
        actions: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 12),
              _buildActionButton(
                  Icons.camera_alt, R.color.defaultConversationColor,
                  iconColor: Colors.white),
              SizedBox(width: 12),
              _buildActionButton(Icons.call, R.color.homeGrey),
              SizedBox(width: 12),
              _buildActionButton(Icons.videocam, R.color.homeGrey),
            ],
          )
        ],
        secondaryActions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _buildActionButton(Icons.view_headline, R.color.homeGrey),
              SizedBox(width: 12),
              _buildActionButton(Icons.notifications, R.color.homeGrey),
              SizedBox(width: 12),
              _buildActionButton(Icons.delete, Colors.red,
                  iconColor: Colors.white, onTap: () {
                _deleteConversation(context, conversation, index);
              }),
              SizedBox(width: 12),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildConversationsList(HomeViewModel viewModel) {
    final conversations = viewModel.conversations;
    return AnimatedList(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      key: _listKey,
      initialItemCount: conversations.length,
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: _buildConversationItem(
            conversations[index],
            index,
            viewModel: viewModel,
            context: context,
          ),
        );
      },
    );
  }

  Widget _buildAppBar(HomeViewModel viewModel) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                UserAvatar(
                  allowToChange: true,
                  size: 32,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Chats",
                  style: R.style.textInAppBar,
                ),
                Visibility(
                  visible:
                      TestSetting.ENABLE_RELOAD_BUTTON_AT_HOME_PAGE.isEnabled(),
                  child: IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      viewModel.loadAddConversations();
                    },
                  ),
                )
              ],
            ),
          ),
          _buildActionButton(Icons.camera_alt, R.color.homeGrey),
          SizedBox(
            width: 16,
          ),
          _buildActionButton(Icons.edit, R.color.homeGrey),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (_) {},
      backgroundColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Colors.black,
            ),
            title: SizedBox(
              height: 0,
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.grey,
            ),
            title: SizedBox(
              height: 0,
            )),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.directions,
              color: Colors.grey,
            ),
            title: SizedBox(
              height: 0,
            )),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Selector<HomeViewModel, bool>(
      selector: (_, __) => false,
      builder: (context, _, __) {
        return FloatingActionButton(
          onPressed: () {
            _createNewConversation(context);
          },
          child: Icon(Icons.add),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModelProvider>(context).homeViewModel();
    return ChangeNotifierProvider(
      builder: (_) => viewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(viewModel),
        body: _buildHomeContent(context),
        floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}
