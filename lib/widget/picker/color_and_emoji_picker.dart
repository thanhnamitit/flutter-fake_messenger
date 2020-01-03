import 'package:conversation_maker/core/util/image_utils.dart';
import 'package:conversation_maker/domain/entity/conversation.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../bubble_tab_bar.dart';

class ColorAndEmojiPicker extends StatefulWidget {
  final Conversation conversation;
  final int tabIndex;

  ColorAndEmojiPicker(this.conversation, this.tabIndex);

  @override
  _ColorAndEmojiPickerState createState() => _ColorAndEmojiPickerState();
}

class _ColorAndEmojiPickerState extends State<ColorAndEmojiPicker>
    with TickerProviderStateMixin {
  PageController _pageController;
  TabController _tabController;

  @override
  void initState() {
    print("initState");
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.tabIndex;
    super.initState();
  }

  void _onEmojiSelected(String emojiPath) {
    _close(widget.conversation.clone..emoji = emojiPath);
  }

  void _onColorSelected(int colorValue) {
    _close(widget.conversation.clone..color = colorValue);
  }

  void _close(Conversation conversation) {
    Navigator.of(context).pop(conversation);
  }

  Widget _buildCommonGridView(
      BuildContext context, Orientation orientation, List<Widget> children) {
    return GridView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.portrait ? 4 : 9,
          childAspectRatio: 4 / 3),
      children: children,
    );
  }

  Widget _buildEmojiPicker(BuildContext context, Orientation orientation) {
    return _buildCommonGridView(
      context,
      orientation,
      List.generate(
        EmojiUtils.all.length,
        (index) {
          String emojiPath = EmojiUtils.all[index];
          return InkWell(onTap: () {
            _onEmojiSelected(emojiPath);
          }, child: LayoutBuilder(
            builder: (_, BoxConstraints constrains) {
              return Container(
                padding: EdgeInsets.all(constrains.maxHeight / 8),
                decoration: widget.conversation.emoji != emojiPath
                    ? null
                    : ShapeDecoration(
                        color: Color(0xffefefef),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                child: SvgPicture.asset(
                  emojiPath,
                  color: emojiPath == EmojiUtils.defaultOne
                      ? Color(widget.conversation.color)
                      : null,
                ),
              );
            },
          ));
        },
      ),
    );
  }

  Widget _buildColorPicker(BuildContext context, Orientation orientation) {
    return _buildCommonGridView(
      context,
      orientation,
      List.generate(
        R.color.conversationColors.length,
        (index) {
          int colorValue = R.color.conversationColors[index];
          return InkWell(onTap: () {
            _onColorSelected(colorValue);
          }, child: LayoutBuilder(
            builder: (_, BoxConstraints constrains) {
              return Container(
                padding: EdgeInsets.all(constrains.maxHeight / 8),
                decoration: widget.conversation.color != colorValue
                    ? null
                    : ShapeDecoration(
                        color: Color(0xffefefef),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(colorValue),
                  ),
                ),
              );
            },
          ));
        },
      ),
    );
  }

  Widget _buildPageView(BuildContext context, Orientation orientation) {
    _pageController = PageController(initialPage: _tabController.index);
    return PageView(
      controller: _pageController,
      onPageChanged: (int index) {
        print("PageView index $index");
        if (_tabController.index != index) _tabController.index = index;
      },
      children: <Widget>[
        _buildColorPicker(context, orientation),
        _buildEmojiPicker(context, orientation),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      margin: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Customize your chat",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: FloatingActionButton(
                    onPressed: () {
                      _close(null);
                    },
                    heroTag: null,
                    backgroundColor: Color(0xffefefef),
                    elevation: .1,
                    child: Icon(
                      Icons.clear,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Flexible(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
              child: OrientationBuilder(
                builder: (_, Orientation orientation) {
                  Widget pageView = _buildPageView(context, orientation);
                  return orientation == Orientation.portrait
                      ? AspectRatio(
                          aspectRatio: 4 / 3,
                          child: pageView,
                        )
                      : Container(
                          child: pageView,
                        );
                },
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: BubbleTabBar(
                controller: _tabController,
                onTap: (int index) {
                  _pageController.jumpToPage(index);
                },
                tabs: <Widget>[
                  Tab(
                    text: "Color".toUpperCase(),
                  ),
                  Tab(
                    text: "Emoji".toUpperCase(),
                  ),
                ],
              )),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
