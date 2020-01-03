import 'dart:io';

import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/page/conversation/conversation_view_model.dart';
import 'package:conversation_maker/page/conversation/dialog/message_option_bottom_sheet.dart';
import 'package:conversation_maker/page/conversation/emoji_item_view_model.dart';
import 'package:conversation_maker/page/conversation/message_item_view_model.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:conversation_maker/widget/dialog/text_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../avatar.dart';
import 'emoji_message_item.dart';
import 'first_message_item.dart';

class NormalMessageItem extends StatefulWidget {
  final MessageItemViewModel _viewModel;

  NormalMessageItem(this._viewModel);

  @override
  _NormalMessageItemState createState() => _NormalMessageItemState();
}

class _NormalMessageItemState extends State<NormalMessageItem> {
  static const double WEAK_BORDER_RADIUS = 2;
  static const double STRONG_BORDER_RADIUS = 16;
  static const weakRadius = Radius.circular(WEAK_BORDER_RADIUS);
  static const strongRadius = Radius.circular(STRONG_BORDER_RADIUS);

  MessageItemViewModel _viewModel;

  @override
  void initState() {
    _viewModel = widget._viewModel;
    super.initState();
  }

  void _updateMessage(Message newMessage) {
    Provider.of<ConversationViewModel>(context).updateMessage(newMessage);
  }

  void _swapMessagePosition() {
    _updateMessage(_viewModel.toggleIsMineFlagMessage);
  }

  void _removeMessage() {
    _updateMessage(_viewModel.toggleRemovedFlagMessage);
  }

  void _deleteMessage() {
    Provider.of<ConversationViewModel>(context)
        .deleteMessage(_viewModel.message);
  }

  void _editMessage() async {
    var newContent = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => TextInputDialog(
              _viewModel.messageContent,
              "Message content",
              _viewModel.conversationColor.value,
            ));
    var messageAfterEditContent = _viewModel.message..content = newContent;
    _updateMessage(messageAfterEditContent);
  }

  void _showOptionalBottomSheet() {
    var bottomSheet = MessageOptionBottomSheet(
      _viewModel,
      _handleSelectedOption,
    );
    showModalBottomSheet(context: context, builder: (_) => bottomSheet);
  }

  void _handleSelectedOption(MessageOption option) {
    switch (option) {
      case MessageOption.Swap:
        _swapMessagePosition();
        break;
      case MessageOption.Delete:
        _deleteMessage();
        break;
      case MessageOption.Edit:
        _editMessage();
        break;
      case MessageOption.Remove:
        _removeMessage();
        break;
      default:
        _handleSelectedStatus(option);
        break;
    }
  }

  void _handleSelectedStatus(MessageOption option) {
    MessageStatus newStatus = MessageStatus.nothing;
    switch (option) {
      case MessageOption.Sending:
        newStatus = MessageStatus.sending;
        break;
      case MessageOption.Sent:
        newStatus = MessageStatus.sent;
        break;
      case MessageOption.Delivered:
        newStatus = MessageStatus.delivered;
        break;
      case MessageOption.Failed:
        newStatus = MessageStatus.failed;
        break;
      case MessageOption.Read:
        newStatus = MessageStatus.read;
        break;
      default:
        break;
    }
    _updateMessage(_viewModel.message
      ..status = newStatus
      ..removed = newStatus == MessageStatus.failed
          ? false
          : _viewModel.message.removed);
  }

  BorderRadius _buildSentMessageBorderRadius(BuildContext context) {
    return BorderRadius.only(
        bottomRight: _viewModel.bottomBorder ? strongRadius : weakRadius,
        topRight: _viewModel.topBorder ? strongRadius : weakRadius,
        bottomLeft: strongRadius,
        topLeft: strongRadius);
  }

  BorderRadius _buildReceivedMessageBorderRadius(BuildContext context) {
    return BorderRadius.only(
        bottomRight: strongRadius,
        topRight: strongRadius,
        bottomLeft: _viewModel.bottomBorder ? strongRadius : weakRadius,
        topLeft: _viewModel.topBorder ? strongRadius : weakRadius);
  }

  Widget _buildMessageStatus(BuildContext context) {
    Widget result;
    if (!_viewModel.isMine) {
      result = Text("");
    } else {
      switch (_viewModel.status) {
        case MessageStatus.sending:
          result = Icon(
            Icons.panorama_fish_eye,
            color: Colors.grey,
            size: 16,
          );
          break;
        case MessageStatus.sent:
          result = Icon(
            Icons.check_circle_outline,
            color: Colors.grey,
            size: 16,
          );
          break;
        case MessageStatus.delivered:
          result = Icon(
            Icons.check_circle,
            color: Colors.grey,
            size: 16,
          );
          break;
        case MessageStatus.read:
          result = MessageCircleAvatar(
            _viewModel.avatarFilePath,
          );
          break;
        case MessageStatus.nothing:
        default:
          result = Text("");
          break;
      }
    }
    return result;
  }

  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Image.file(
        File(_viewModel.messageContent),
        width: 130,
      ),
    );
  }

  Widget _buildMessageBody(BuildContext context) {
    if (_viewModel.removed) {
      return _buildMessageText(context);
    }
    Widget result;
    switch (_viewModel.type) {
      case MessageType.emoji:
      case MessageType.emojiPreview:
        result = EmojiMessageItem(_viewModel as EmojiItemViewModel);
        break;
      case MessageType.sticker:
        result = SizedBox(
          width: 120,
          height: 120,
          child: Image.asset(
            _viewModel.messageContent,
            fit: BoxFit.scaleDown,
          ),
        );
        break;
      case MessageType.image:
        result = _buildImageMessage();
        break;
      default:
        result = _buildMessageText(context);
        break;
    }
    return result;
  }

  Widget _buildMessagemoji(BuildContext context, String asset, int size) {}

  Widget _buildMessageText(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: 34, maxWidth: MediaQuery.of(context).size.width * 0.65),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: _buildBackgroundDecoration(context),
      child: Text(
        _viewModel.messageContent,
        style: TextStyle(
            color: _viewModel.removed
                ? R.color.removedMessageColor
                : _viewModel.isMine ? Colors.white : Colors.black,
            fontStyle:
                _viewModel.removed ? FontStyle.italic : FontStyle.normal),
      ),
    );
  }

  Decoration _buildBackgroundDecoration(BuildContext context) {
    return ShapeDecoration(
      color: _viewModel.removed
          ? Colors.transparent
          : _viewModel.isMine
              ? _viewModel.conversationColor.withOpacity(
                  _viewModel.status == MessageStatus.failed ? 0.4 : 1)
              : Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: _viewModel.removed
                ? R.color.removedMessageColor
                : Colors.transparent),
        borderRadius: _viewModel.isMine
            ? _buildSentMessageBorderRadius(context)
            : _buildReceivedMessageBorderRadius(context),
      ),
    );
  }

  Widget _buildNormalMessageItem(BuildContext context) {
    return ChangeNotifierProvider<MessageItemViewModel>.value(
      value: _viewModel,
      child: Consumer<MessageItemViewModel>(
        builder: (_, viewModel, __) {
          return InkWell(
            onTap: _showOptionalBottomSheet,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: viewModel.isFailMessage ? 4 : 1, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Opacity(
                        opacity: viewModel.showAvatar ?? false ? 1 : 0,
                        child: MessageCircleAvatar(_viewModel.avatarFilePath),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 12),
                          alignment: _viewModel.isMine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: _buildMessageBody(context),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: R.number.userMessageRightMargin,
                        height: R.number.userMessageRightMargin,
                        child: _buildMessageStatus(context),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: viewModel.showFailMessage,
                    maintainSize: false,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 1, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.exclamationTriangle,
                            size: 14,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "This message failed to send. Click to\n send again.",
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _viewModel.type == MessageType.green
        ? GreenMessageItem(_viewModel)
        : _buildNormalMessageItem(context);
  }
}
