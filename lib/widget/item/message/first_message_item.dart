import 'package:conversation_maker/core/constant/constant.dart';
import 'package:conversation_maker/page/conversation/message_item_view_model.dart';
import 'package:flutter/material.dart';

import '../../avatar.dart';

class GreenMessageItem extends StatefulWidget {
  final MessageItemViewModel _viewModel;

  GreenMessageItem(this._viewModel);

  @override
  _GreenMessageItemState createState() => _GreenMessageItemState();
}

class _GreenMessageItemState extends State<GreenMessageItem> {
  MessageItemViewModel _viewModel;

  @override
  void initState() {
    _viewModel = widget._viewModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            MessageCircleAvatar(
              _viewModel.avatarFilePath,
              size: 96,
            ),
            Visibility(
              visible: _viewModel.conversationIsActive,
              child: Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      shape: BoxShape.circle,
                      color: SpecialColors.FACEBOOK_ACTIVE_STATUS_COLOR),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _viewModel.conversationName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          _viewModel.conversationContentBellowName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          _viewModel.conversationFirstLineContent,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          _viewModel.conversationSecondLineContent,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          _viewModel.createTime.toUpperCase(),
          style: TextStyle(
            color: Colors.black38,
            fontSize: 12,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          height: 48,
          child: AspectRatio(
            aspectRatio: 3.6 / 2,
            child: Stack(
              children: <Widget>[
                MessageCircleAvatar.user(
                  size: 48,
                  border: AvatarBorder(2, Colors.white),
                  backgroundColor: Colors.white,
                ),
                Positioned(
                  right: 0,
                  child: MessageCircleAvatar(
                    _viewModel.avatarFilePath,
                    size: 48,
                    border: AvatarBorder(2, Colors.white),
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 26,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _viewModel.greenBellowCoupleAvatarsContent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: MessageCircleAvatar(
                _viewModel.avatarFilePath,
                size: 18,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 42,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  _viewModel.greenWithAWaveContent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 18),
              child: FloatingActionButton(
                onPressed: () {},
                heroTag: null,
                backgroundColor: Color(0xffefefef),
                elevation: .1,
                child: Icon(
                  Icons.clear,
                  size: 15,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 24,
        ),
        Image.asset(
          "assets/img_wave.png",
          width: 72,
          height: 72,
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Text(
            "Wave".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18))),
            color: Color(0xffefefef),
          ),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
