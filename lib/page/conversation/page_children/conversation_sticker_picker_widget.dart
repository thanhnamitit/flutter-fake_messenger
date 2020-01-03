import 'package:conversation_maker/core/util/image_utils.dart';
import 'package:conversation_maker/domain/entity/factory/message_factory.dart';
import 'package:conversation_maker/page/conversation/conversation_view_model.dart';
import 'package:conversation_maker/widget/bubble_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StickerPicker extends StatefulWidget {
  @override
  _StickerPickerState createState() => _StickerPickerState();
}

class _StickerPickerState extends State<StickerPicker>
    with TickerProviderStateMixin {
  TabController _topTabController;
  TabController _bottomTabController;
  PageController _pageController;
  List<StickerGroup> _stickerGroups;

  final int _initPageIndex = 2;

  @override
  void initState() {
    _stickerGroups = StickerUtils.all();
    _topTabController = TabController(length: 3, vsync: this);
    _bottomTabController =
        TabController(length: _stickerGroups.length + 2, vsync: this);
    _bottomTabController.index = _initPageIndex;
    super.initState();
  }

  void _onStickerPicked(String assetPath) {
    var viewModel = Provider.of<ConversationViewModel>(context);
    viewModel.addNewMessage(
        MessageFactory.sticker(assetPath, viewModel.conversation.id));
    print(assetPath);
  }

  void _onPageSelected(index) {}

  Widget _buildTopTabBar() {
    return BubbleTabBar(
        onTap: (int index) {},
        controller: _topTabController,
        tabs: <Widget>[
          Tab(
            text: "Stickers".toUpperCase(),
          ),
          Tab(
            text: "Gifts".toUpperCase(),
          ),
          Tab(
            text: "Emoji".toUpperCase(),
          ),
        ]);
  }

  Widget _buildBottomTabBar() {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: TabBar(
              onTap: (int index) {
                _pageController.jumpToPage(index);
              },
              controller: _bottomTabController,
              indicatorColor: Colors.black,
              isScrollable: true,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 12),
              labelPadding: EdgeInsets.symmetric(horizontal: 14),
              tabs: <Widget>[
                Tab(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                ),
              ]..addAll(_stickerGroups.map((it) => Image.asset(
                    it.assetPaths[0],
                    width: 32,
                    height: 32,
                  ))),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            color: Color(0xffededed),
            width: 1,
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              Positioned(
                top: 0,
                right: 2,
                child: Container(
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: Text(
                    "9+",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStickerPageView(Orientation orientation) {
    _pageController = PageController(initialPage: _bottomTabController.index);
    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height /
              (orientation == Orientation.portrait ? 3 : 3.5)),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (int index) {
          if (_bottomTabController.index != index) {
            _bottomTabController.index = index;
          }
        },
        itemBuilder: (_, int index) {
          return (index == 0 || index == 1)
              ? Container()
              : GridView(
                  padding:
                      EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 4 : 8,
                      childAspectRatio: 1 / 1),
                  children:
                      _stickerGroups[index - 2].assetPaths.map((assetPath) {
                    return InkWell(
                        onTap: () {
                          _onStickerPicked(assetPath);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(assetPath),
                        ));
                  }).toList(),
                );
        },
        itemCount: _stickerGroups.length + 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff5f5f5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTopTabBar(),
          _buildStickerPageView(MediaQuery.of(context).orientation),
          Divider(
            color: Color(0xffdbdbdd),
            height: 5,
          ),
          _buildBottomTabBar(),
        ],
      ),
    );
  }
}
