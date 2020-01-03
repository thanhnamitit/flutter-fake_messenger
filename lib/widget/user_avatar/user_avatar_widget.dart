import 'dart:io';

import 'package:conversation_maker/core/util/image_picker_utils.dart';
import 'package:conversation_maker/di/provider/view_model_provider.dart';
import 'package:conversation_maker/widget/user_avatar/user_avatar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resource/R.dart';

class UserAvatar extends StatefulWidget {
  final bool allowToChange;
  final double size;

  UserAvatar({this.allowToChange = false, this.size = 32});

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  void _changeAvatar(BuildContext context) async {
    final newAvatar = await ImagePickerUtils.pickImageWithCropper();
    if (newAvatar != null) {
      Provider.of<UserAvatarViewModel>(context).avatar = newAvatar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) =>
          Provider.of<ViewModelProvider>(context).userAvatarViewModel(),
      child: Consumer<UserAvatarViewModel>(
        builder: (context, viewModel, __) {
          final path = viewModel.avatar;
          return InkWell(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (widget.allowToChange) {
                _changeAvatar(context);
              }
            },
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircleAvatar(
                backgroundImage: path == null
                    ? AssetImage(R.drawable.defaultAvatar)
                    : FileImage(File(path)),
              ),
            ),
          );
        },
      ),
    );
  }
}
