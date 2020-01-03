import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class BubbleTabBar extends StatefulWidget {
  final List<Widget> tabs;
  final ValueChanged<int> onTap;
  final TabController controller;

  BubbleTabBar({this.tabs, this.onTap, this.controller});

  @override
  _BubbleTabBarState createState() => _BubbleTabBarState();
}

class _BubbleTabBarState extends State<BubbleTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.black,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      indicatorColor: Colors.transparent,
      unselectedLabelColor: Colors.grey,
      controller: widget.controller,
      indicatorSize: TabBarIndicatorSize.label,
      onTap: widget.onTap,
      indicator: BubbleTabIndicator(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          indicatorColor: Color(0xffe7e7e7),
          tabBarIndicatorSize: TabBarIndicatorSize.label,
          indicatorRadius: 12),
      tabs: widget.tabs,
    );  }
}
