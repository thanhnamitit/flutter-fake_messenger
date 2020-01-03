import 'package:conversation_maker/core/base/widget/bounce_button.dart';
import 'package:conversation_maker/core/helper/UIHelpers.dart';
import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:conversation_maker/widget/item/dynamic_circle_avatar.dart';
import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final Story _story;

  StoryItem(this._story);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 5;
    final avatarSize = width * 3 / 4.5;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BounceButton(
            onTap: () {},
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: !_story.seen
                      ? R.color.defaultConversationColor
                      : Colors.grey.withAlpha(150),
                  width: 3,
                ),
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Container(
                padding: EdgeInsets.all(3),
                child: DynamicCircleAvatar(
                  assetPath: R.drawable.defaultAvatar,
                  filePath: _story.avatar,
                ),
              ),
            ),
          ),
          verticalSpaceMedium,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: width,
              child: Text(
                _story.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
