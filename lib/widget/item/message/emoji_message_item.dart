import 'dart:math';

import 'package:conversation_maker/core/util/image_utils.dart';
import 'package:conversation_maker/domain/entity/message.dart';
import 'package:conversation_maker/page/conversation/emoji_item_view_model.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:provider/provider.dart';

import '../../emoji.dart';

class EmojiMessageItem extends StatefulWidget {
  final EmojiItemViewModel _viewModel;

  EmojiMessageItem(this._viewModel);

  @override
  _EmojiMessageItemState createState() => _EmojiMessageItemState();
}

class _EmojiMessageItemState extends State<EmojiMessageItem>
    with SingleTickerProviderStateMixin {
  static const int EMOJI_BOUNCE_DURATION_IN_MILLIS = 200;

  static const String TAG_ANIM_SIZE = "size";
  static const String TAG_ANIM_ANGEL = "angel";
  static const double MAX_FACTOR_TO_TRANSFORM = 1.8;

  AnimationController _controller;

  @override
  void initState() {
    widget._viewModel.messageTransformedNotifier
        .listen((_) => previewHaveTransformedToOfficial());
    super.initState();
  }

  void previewHaveTransformedToOfficial() {
    final viewModel = widget._viewModel;
    _controller = AnimationController(
      duration: Duration(milliseconds: EMOJI_BOUNCE_DURATION_IN_MILLIS),
      vsync: this,
    );

    final beginSize = viewModel.size;
    final middleSize = (viewModel.finalSize > viewModel.size
            ? viewModel.finalSize
            : viewModel.size) *
        MAX_FACTOR_TO_TRANSFORM;
    final endSize = viewModel.finalSize;

    print("$beginSize $middleSize $endSize");
    final sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
          animatable: new Tween<double>(begin: beginSize, end: middleSize),
          from: Duration(milliseconds: 0),
          to: Duration(milliseconds: EMOJI_BOUNCE_DURATION_IN_MILLIS ~/ 2),
          tag: TAG_ANIM_SIZE,
        )
        .addAnimatable(
          animatable: new Tween<double>(begin: middleSize, end: endSize),
          from: Duration(milliseconds: EMOJI_BOUNCE_DURATION_IN_MILLIS ~/ 2),
          to: Duration(milliseconds: EMOJI_BOUNCE_DURATION_IN_MILLIS),
          tag: TAG_ANIM_SIZE,
        )
        .addAnimatable(
          animatable: new Tween<double>(begin: 0, end: -pi / 12),
          from: Duration(milliseconds: 0),
          to: Duration(milliseconds: EMOJI_BOUNCE_DURATION_IN_MILLIS ~/ 2),
          tag: TAG_ANIM_ANGEL,
        )
        .addAnimatable(
          animatable: new Tween<double>(begin: -pi / 12, end: 0),
          from: Duration(milliseconds: EMOJI_BOUNCE_DURATION_IN_MILLIS ~/ 2),
          to: Duration(milliseconds: EMOJI_BOUNCE_DURATION_IN_MILLIS),
          tag: TAG_ANIM_ANGEL,
        )
        .animate(_controller);
    _controller.addListener(() {
      viewModel.onSizeChange(
        size: sequenceAnimation[TAG_ANIM_SIZE].value,
        angel: sequenceAnimation[TAG_ANIM_ANGEL].value,
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    widget._viewModel.messageTransformedNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget._viewModel,
      child: Consumer<EmojiItemViewModel>(
        builder: (_, viewModel, __) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Transform.rotate(
              angle: viewModel.angel,
              child: Emoji(
                viewModel.asset,
                color: EmojiUtils.isDefaultOne(viewModel.asset)
                    ? widget._viewModel.conversationColor
                    : null,
                opacity: widget._viewModel.status == MessageStatus.failed
                    ? R.number.opacityMessageFail
                    : R.number.opacityMessageSuccess,
                size: R.number.emojiDefaultSize * viewModel.size,
              ),
            ),
          );
        },
      ),
    );
  }
}
