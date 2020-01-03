import 'dart:io';

import 'package:conversation_maker/core/constant/constant.dart';
import 'package:conversation_maker/widget/user_avatar/user_avatar_widget.dart';
import 'package:flutter/material.dart';

import '../resource/R.dart';

class AvatarBorder {
  final double width;
  final Color color;

  AvatarBorder(this.width, this.color);
}

class MessageCircleAvatar extends StatelessWidget {
  final String _avatarFilePath;
  final double size;
  final AvatarBorder border;
  final Color backgroundColor;
  final isUserAvatar;

  MessageCircleAvatar(this._avatarFilePath,
      {this.size = 36,
      this.border,
      this.backgroundColor,
      this.isUserAvatar = false});

  factory MessageCircleAvatar.user(
      {double size = 36, AvatarBorder border, Color backgroundColor}) {
    return MessageCircleAvatar(
      "",
      size: size,
      border: border,
      backgroundColor: backgroundColor,
      isUserAvatar: true,
    );
  }

  Widget _buildUserAvatar() {
    return UserAvatar();
  }

  Widget _buildNormalAvatar(Color bgColor) {
    return CircleAvatar(
      backgroundColor: bgColor,
      backgroundImage: _avatarFilePath != null
          ? FileImage(File(_avatarFilePath))
          : AssetImage(R.drawable.defaultAvatar),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor =
        backgroundColor ?? AvatarConstant.DEFAULT_AVATAR_BACKGROUND_COLOR;
    return Container(
      width: size,
      height: size,
      decoration: border == null
          ? null
          : BoxDecoration(
              border: Border.all(color: border.color, width: border.width),
              shape: BoxShape.circle,
              color: SpecialColors.FACEBOOK_ACTIVE_STATUS_COLOR),
      child: isUserAvatar ? _buildUserAvatar() : _buildNormalAvatar(bgColor),
    );
  }
}
