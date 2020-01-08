import 'package:conversation_maker/core/constant/constant.dart';
import 'package:conversation_maker/core/helper/UIHelpers.dart';
import 'package:conversation_maker/core/util/image_picker_utils.dart';
import 'package:conversation_maker/core/util/image_utils.dart';
import 'package:conversation_maker/core/util/keyboard_utils.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/page/conversation/conversation_view_model.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:conversation_maker/widget/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'conversation_sticker_picker_widget.dart';

class ConversationInput extends StatefulWidget {
  @override
  _ConversationInputState createState() => _ConversationInputState();
}

class _ConversationInputState extends State<ConversationInput>
    with SingleTickerProviderStateMixin {
  static const int ANIM_EMOJI_DURATION = 4;

  final _textInputController = TextEditingController();
  FocusNode _textInputFocusNote = FocusNode();
  bool _hasTextContent = false;
  bool _keyboardVisible = false;
  bool _forceShowFunctionButton = false;
  bool _isSelectingSticker = false;

  AnimationController _controller;
  Animation<double> _animation;

  List<Function> _taskWhenKeyboardClosed = [];

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setupKeyboard();
  }

  @override
  void dispose() {
    _textInputController.dispose();
    super.dispose();
  }

  void _setupAnimation() {
    _controller = AnimationController(
        duration: const Duration(seconds: ANIM_EMOJI_DURATION), vsync: this);
    _animation = Tween(
      begin: R.number.ratioEmojiMin,
      end: R.number.ratioEmojiMax,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic))
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.dismissed:
          case AnimationStatus.forward:
          case AnimationStatus.reverse:
            // do nothing
            break;
          case AnimationStatus.completed:
            _removeEmojiPreviewMessage();
            break;
        }
      })
      ..addListener(
        () {
          double animValue = _animation.value;
          // if  animation be canceled then receive last callback with animValue = begin value (R.number.ratioEmojiMin)
          if (animValue != R.number.ratioEmojiMin) {
            Provider.of<ConversationViewModel>(context)
                .emojiSizeChange(animValue);
          }
        },
      );
  }

  void _setupKeyboard() {
    KeyboardVisibilityNotification().addNewListener(onChange: (bool visible) {
      setState(() {
        _forceShowFunctionButton = false;
        _keyboardVisible = visible;
        if (visible) {
          _isSelectingSticker = false;
        } else {
          _taskWhenKeyboardClosed.forEach((f) => f());
          _taskWhenKeyboardClosed.clear();
        }
      });
    });
  }

  void _toggleStickerPicker() {
    if (!_isSelectingSticker) {
      if (_keyboardVisible) {
        KeyboardUtils.hideKeyboard(context);
        _taskWhenKeyboardClosed.add(() {
          _isSelectingSticker = true;
        });
      } else {
        setState(() {
          _isSelectingSticker = true;
        });
      }
    } else {
      FocusScope.of(context).requestFocus(_textInputFocusNote);
      setState(() {
        _isSelectingSticker = false;
      });
    }
  }

  bool _showFunctionButtons() {
    return (!_hasTextContent && !_keyboardVisible) || _forceShowFunctionButton;
  }

  void _onForceShowFunctionButtonRequested() {
    setState(() {
      _forceShowFunctionButton = true;
    });
  }

  void _onTextContentChanged(String content) {
    content = content.trim();
    setState(() {
      _forceShowFunctionButton = content.isEmpty;
      _hasTextContent = content.isNotEmpty;
    });
  }

  void _onSendRequested(BuildContext context, Conversation conversation) {
    String content = _textInputController.text.trim();
    if (content.isNotEmpty) {
      print(content);
      Provider.of<ConversationViewModel>(context)
          .addNewMessage(MessageFactory.text(content, conversation.id));
    }
    _textInputController.clear();
    _onTextContentChanged("");
  }

  void _startEmojiPreviewAnim() {
    _controller.forward();
  }

  void _stopEmojiPreviewAnim() {
    _controller.reset();
  }

  void _addEmojiPreviewMessage() {
    Provider.of<ConversationViewModel>(context).addEmojiPreviewMessage();

    _startEmojiPreviewAnim();
  }

  void _removeEmojiPreviewMessage() {
    Provider.of<ConversationViewModel>(context).removeEmojiPreviewMessage();
    _stopEmojiPreviewAnim();
  }

  void _addEmojiMessage(Conversation conversation) {
    int size = _animation.value.round().toInt();
    Provider.of<ConversationViewModel>(context).addNewMessage(
        MessageFactory.emoji("${conversation.emoji}-$size", conversation.id));
    _stopEmojiPreviewAnim();
  }

  Future _onPickImageRequested() async {
    var imageFile = await ImagePickerUtils.pickImage();
    if (imageFile != null) {
      _addImage(imageFile);
    }
  }

  Future _onTakePictureRequested() async {
    var imageFile = await ImagePickerUtils.takePicture();
    if (imageFile != null) {
      _addImage(imageFile);
    }
  }

  void _addImage(String imageUrl) {
    Provider.of<ConversationViewModel>(context)
        .addNewMessage(MessageFactory.image(imageUrl));
  }

  Widget _buildIconButton(String asset, Conversation conversation,
      {VoidCallback onPressed}) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Emoji(
          asset,
          color: _isSelectingSticker
              ? SpecialColors.FACEBOOK_DISABLE_COLOR
              : Color(conversation.color),
          size: 18,
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _buildLikeButton(BuildContext context, Conversation conversation) {
    return GestureDetector(
      onTapDown: (_) {
        _addEmojiPreviewMessage();
      },
      onTapUp: (_) {
        _addEmojiMessage(conversation);
      },
      onTapCancel: () {
        _removeEmojiPreviewMessage();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          conversation.emoji,
          width: 22,
          height: 22,
          color: conversation.emoji == EmojiUtils.defaultOne
              ? Color(conversation.color)
              : null,
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context, Conversation conversation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            horizontalSpaceLarge,
            Visibility(
              visible: _showFunctionButtons(),
              replacement: _buildIconButton(
                  "assets/ic_arrow_right.svg", conversation,
                  onPressed: _onForceShowFunctionButtonRequested),
              child: Row(
                children: <Widget>[
                  _buildIconButton("assets/ic_four_dots.svg", conversation,
                      onPressed: () {}),
                  _buildIconButton("assets/ic_camera.svg", conversation,
                      onPressed: _onTakePictureRequested),
                  _buildIconButton("assets/ic_photo.svg", conversation,
                      onPressed: _onPickImageRequested),
                  _buildIconButton("assets/ic_microphone.svg", conversation,
                      onPressed: () {}),
                  verticalSpaceMedium
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: Color(0xffefefef)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        expands: false,
                        maxLines: 1,
                        focusNode: _textInputFocusNote,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: _onTextContentChanged,
                        controller: _textInputController,
                        decoration: InputDecoration(
                          hintText: _showFunctionButtons()
                              ? "Aa"
                              : "Type a message...",
                          hintStyle: TextStyle(
                            color: SpecialColors.FACEBOOK_DISABLE_COLOR,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          height: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    InkWell(
                      onTap: _toggleStickerPicker,
                      child: Icon(
                        Icons.tag_faces,
                        color: Color(conversation.color),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Visibility(
              visible: _hasTextContent,
              replacement: _buildLikeButton(context, conversation),
              child: InkWell(
                  onTap: () {
                    _onSendRequested(context, conversation);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.send,
                      size: 22,
                      color: Color(conversation.color),
                    ),
                  )),
            ),
            SizedBox(
              width: 4,
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Visibility(
          maintainState: true,
          visible: _isSelectingSticker,
          child: StickerPicker(),
        ),
      ],
    );
  }

  Widget _buildBlockedMessage(BuildContext context, Conversation conversation) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      color: Color(conversation.color),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: "You can't reply to this conversation. ",
                style: TextStyle(color: Colors.white, fontSize: 14)),
            TextSpan(
                text: "Learn More",
                style: TextStyle(
                    fontSize: 14,
                    decorationColor: Colors.white,
                    decorationStyle: TextDecorationStyle.solid,
                    decoration: TextDecoration.underline))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationViewModel>(
      builder: (_, viewModel, __) {
        Conversation conversation = viewModel.conversation;
        return conversation.blocked
            ? _buildBlockedMessage(context, conversation)
            : _buildInput(context, conversation);
      },
    );
  }
}
