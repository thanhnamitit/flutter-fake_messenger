import 'dart:async';

import 'package:conversation_maker/core/util/image_picker_utils.dart';
import 'package:conversation_maker/core/util/image_utils.dart';
import 'package:conversation_maker/di/provider/view_model_provider.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/page/edit_conversation/edit_conversation_view_model.dart';
import 'package:conversation_maker/widget/avatar.dart';
import 'package:conversation_maker/widget/dialog/text_input_dialog.dart';
import 'package:conversation_maker/widget/emoji.dart';
import 'package:conversation_maker/widget/picker/color_and_emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditConversationPage extends StatefulWidget {
  final Conversation _conversation;

  EditConversationPage(this._conversation);

  @override
  _EditConversationPageState createState() => _EditConversationPageState();
}

class _EditConversationPageState extends State<EditConversationPage>
    with TickerProviderStateMixin {
  static const HORIZONTAL_PADDING = 24.0;
  static const LABEL_FONT_SIZE = 14.0;
  static const CONTENT_FONT_SIZE = 15.0;
  Animation<double> _cameraScaleAnimation;
  Timer _timer;

  void _updateConversation(BuildContext context, Conversation conversation) {
    Provider.of<EditConversationViewModel>(context)
        .updateConversation(conversation);
  }

  void _save(BuildContext context, Conversation conversation) {
    Navigator.of(context).pop(conversation);
  }

  Future<String> getNewContent(
      String currentValue, String title, int color, bool nullable) async {
    var newContent = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TextInputDialog(
        currentValue,
        title,
        color,
        nullable: nullable,
      ),
    );
    return newContent;
  }

  void _requestUpdateName(
      BuildContext context, Conversation conversation) async {
    var newName = await getNewContent(
        conversation.name, "Edit name", conversation.color, false);
    if (newName != null) {
      _updateConversation(context, conversation.clone..name = newName);
    }
  }

  void _requestUpdateStatus(
      BuildContext context, Conversation conversation) async {
    var newStatus = await getNewContent(
        conversation.status, "Edit status", conversation.color, true);
    if (newStatus != null) {
      _updateConversation(context, conversation.clone..status = newStatus);
    }
  }

  void _requestUpdateAvatar(
      BuildContext context, Conversation conversation) async {
    String newAvatar = await ImagePickerUtils.pickImageWithCropper();
    if (newAvatar != null) {
      _updateConversation(
        context,
        conversation.clone..avatar = newAvatar,
      );
    }
  }

  Future _openPicker(
      BuildContext context, Conversation conversation, int pageIndex) async {
    Conversation updatedConversation = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => ColorAndEmojiPicker(conversation, pageIndex));
    if (updatedConversation != null)
      _updateConversation(context, updatedConversation);
  }

  Future _pickColor(BuildContext context, Conversation conversation) async {
    _openPicker(context, conversation, 0);
  }

  Future _pickEmoji(BuildContext context, Conversation conversation) async {
    _openPicker(context, conversation, 1);
  }

  @override
  void initState() {
    //  _bloc = EditConversationBloc(widget._conversation);
    final controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 200,
        ));
    _cameraScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);
    _timer = Timer(Duration(milliseconds: 400), () {
      controller.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //   _bloc.dispose();
    _timer.cancel();
  }

  Widget _buildAppBar(BuildContext context, EditConversationViewModel state) {
    return AppBar(
      iconTheme: IconThemeData(color: Color(state.conversation.color)),
      backgroundColor: Colors.white,
      title: Text(
        state.conversation.name,
        style: TextStyle(
            color: Color(state.conversation.color),
            fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: <Widget>[
        Visibility(
          visible: state.hasChanged,
          child: IconButton(
            onPressed: () {
              _save(context, state.conversation);
            },
            icon: Icon(Icons.done),
            tooltip: "Save",
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context, Conversation conversation) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12.0,
                  ),
                ]),
                child: Hero(
                  tag: "avatar${conversation.id}",
                  child: MessageCircleAvatar(
                    conversation.avatar,
                    size: 96,
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: ScaleTransition(
                    scale: _cameraScaleAnimation,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: FloatingActionButton(
                        backgroundColor: Color(conversation.color),
                        child: Icon(
                          Icons.camera_alt,
                          size: 14,
                        ),
                        onPressed: () {
                          _requestUpdateAvatar(context, conversation);
                        },
                      ),
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 24,
          ),
          ListTile(
            title: Text("Name"),
            subtitle: Text(conversation.name),
            onTap: () {
              _requestUpdateName(context, conversation);
            },
          ),
          ListTile(
            title: Text("Status"),
            subtitle: Text(conversation.status),
            onTap: () {
              _requestUpdateStatus(context, conversation);
            },
          ),
          CheckboxListTile(
              value: conversation.isActive,
              title: Text("Active"),
              activeColor: Color(conversation.color),
              onChanged: (bool value) {
                _updateConversation(
                    context, conversation.clone..isActive = value);
              }),
          CheckboxListTile(
              activeColor: Color(conversation.color),
              value: conversation.blocked,
              title: Text("Blocked"),
              onChanged: (bool value) {
                _updateConversation(
                    context, conversation.clone..blocked = value);
              }),
          ListTile(
            title: Text("Color"),
            onTap: () {
              _pickColor(context, conversation);
            },
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Color(conversation.color), width: 8)),
              ),
            ),
          ),
          ListTile(
            title: Text("Emoji"),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Emoji(
                conversation.emoji,
                color: conversation.emoji == EmojiUtils.defaultOne
                    ? Color(conversation.color)
                    : null,
                size: 24,
              ),
            ),
            onTap: () {
              _pickEmoji(context, conversation);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => ViewModelProvider.of(context)
          .editConversationViewModel(widget._conversation),
      child: Consumer<EditConversationViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: _buildAppBar(context, viewModel),
              body: _buildBody(context, viewModel.conversation));
        },
      ),
    );
  }
}
