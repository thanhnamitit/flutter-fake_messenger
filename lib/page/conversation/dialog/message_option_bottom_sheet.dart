import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../message_item_view_model.dart';

class MessageOptionBottomSheet extends StatelessWidget {
  final MessageItemViewModel _viewModel;
  final Function _onOptionSelect;

  MessageOptionBottomSheet(this._viewModel, this._onOptionSelect);

  void _handleOption(BuildContext context, MessageOption option) {
    Navigator.pop(context);
    _onOptionSelect(option);
  }

  Widget _buildStatusSelector(BuildContext context) {
    return Visibility(
      visible: _viewModel.isMine,
      child: ExpansionTile(
        leading: Icon(Icons.remove),
        title: Text("Status"),
        children: <Widget>[
          ListTile(
            onTap: () {
              _handleOption(context, MessageOption.Sending);
            },
            leading: Icon(
              Icons.panorama_fish_eye,
            ),
            title: Text("Sending"),
          ),
          ListTile(
            onTap: () {
              _handleOption(context, MessageOption.Sent);
            },
            leading: Icon(
              Icons.check_circle_outline,
            ),
            title: Text("Sent"),
          ),
          ListTile(
            onTap: () {
              _handleOption(context, MessageOption.Delivered);
            },
            leading: Icon(
              Icons.check_circle,
            ),
            title: Text("Delivered"),
          ),
          ListTile(
            onTap: () {
              _handleOption(context, MessageOption.Failed);
            },
            leading: Transform.scale(
              alignment: Alignment.centerLeft,
              scale: .75,
              child: Icon(
                FontAwesomeIcons.exclamationTriangle,
                color: Colors.red,
              ),
            ),
            title: Text("Failed"),
          ),
          ListTile(
            onTap: () {
              _handleOption(context, MessageOption.Read);
            },
            leading: Transform.scale(
              alignment: Alignment.centerLeft,
              scale: 0.55,
              child: MessageCircleAvatar(_viewModel.avatarFilePath),
            ),
            title: Text("Read"),
          ),
          ListTile(
            onTap: () {
              _handleOption(context, MessageOption.NoStatus);
            },
            leading: Text(""),
            title: Text("No Status"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Card(
        margin: EdgeInsets.all(12),
        elevation: 12,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildStatusSelector(context),
              Visibility(
                maintainSize: false,
                visible:
                    !_viewModel.removed && _viewModel.type != MessageType.emoji,
                child: ListTile(
                  onTap: () {
                    _handleOption(context, MessageOption.Edit);
                  },
                  leading: Icon(Icons.edit),
                  title: Text("Edit"),
                ),
              ),
              ListTile(
                onTap: () {
                  _handleOption(context, MessageOption.Delete);
                },
                leading: Icon(Icons.delete),
                title: Text("Delete"),
              ),
              ListTile(
                onTap: () {
                  _handleOption(context, MessageOption.Remove);
                },
                leading:
                    Icon(_viewModel.removed ? Icons.restore : Icons.remove),
                title: Text(_viewModel.removed ? "Restore" : "Remove"),
              ),
              ListTile(
                onTap: () {
                  _handleOption(context, MessageOption.Swap);
                },
                leading: Icon(Icons.swap_horiz),
                title: Text(
                    _viewModel.isMine ? "Move to rececived" : "Move to sent"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum MessageOption {
  Edit,
  Swap,
  Delete,
  Remove,
  Sending,
  Sent,
  Delivered,
  Failed,
  Read,
  NoStatus
}
