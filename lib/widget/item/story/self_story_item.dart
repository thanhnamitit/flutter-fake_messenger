import 'package:conversation_maker/core/base/widget/bounce_button.dart';
import 'package:conversation_maker/core/helper/UIHelpers.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:flutter/material.dart';

class SelfStoryItem extends StatelessWidget {
  final Function onTap;

  const SelfStoryItem({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 5;
    final avatarSize = width * 3 / 4.5;
    final plusIconSize = avatarSize * 3 / 4.5;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BounceButton(
            onTap: onTap,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: R.color.homeGrey,
              ),
              child: Icon(
                Icons.add,
                size: plusIconSize,
              ),
            ),
          ),
          verticalSpaceMedium,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Your Story",
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
