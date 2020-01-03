import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/page/conversation/message_item_view_model.dart';
import 'package:flutter/material.dart';

import 'first_message_item.dart';
import 'normal_message_item.dart';

class MessageItem extends StatelessWidget {
  final MessageItemViewModel _viewModel;

  MessageItem(this._viewModel);

  @override
  Widget build(BuildContext context) {
    Widget result;
    switch (_viewModel.type) {
      case MessageType.green:
        result = GreenMessageItem(_viewModel);
        break;
      default:
        result = NormalMessageItem(_viewModel);
        break;
    }
    return result;
  }
}
