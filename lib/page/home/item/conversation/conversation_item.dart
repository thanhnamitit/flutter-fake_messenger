import 'dart:io';

import 'package:conversation_maker/core/constant/constant.dart';
import 'package:conversation_maker/page/home/item/conversation/conversation_item_view_model.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  final ConversationItemViewModel _viewModel;
  final Function _onSelected;

  ConversationItem(this._viewModel, this._onSelected);

  @override
  Widget build(BuildContext context) {
    var commonContentStyle = TextStyle(
        decoration: TextDecoration.none,
        fontSize: 13,
        color: Colors.grey,
        fontWeight: FontWeight.w500);
    return Container(
      height: 78,
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 18),
        color: Colors.white,
        onPressed: () {
          print("Selected");
          _onSelected(_viewModel.conversation);
        },
        child: Row(
          children: <Widget>[
            Hero(
              tag: "avatar${_viewModel.id}",
              child: SizedBox(
                width: 52,
                height: 52,
                child: CircleAvatar(
                  backgroundImage: _viewModel.avatar == null
                      ? AssetImage(AvatarConstant.DEFAULT_AVATAR_ASSETS_FILE)
                      : FileImage(File(_viewModel.avatar)),
                ),
              ),
            ),
            SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _viewModel.name,
                    maxLines: 1,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          _viewModel.lastMessageContent,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: commonContentStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      Text(
                        _viewModel.lastTime,
                        style: commonContentStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
