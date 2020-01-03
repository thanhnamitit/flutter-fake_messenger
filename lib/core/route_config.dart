import 'package:conversation_maker/page/conversation/conversation_page.dart';
import 'package:conversation_maker/page/edit_conversation/edit_conversation_page.dart';
import 'package:conversation_maker/page/home/home_page.dart';
import 'package:conversation_maker/page/new_conversation/new_conversation_page.dart';
import 'package:conversation_maker/page/splash/splash_page.dart';
import 'package:conversation_maker/page/story/setup/setup_story_page.dart';
import 'package:flutter/material.dart';

class RouteConfig {
  static const ROUTE_INIT = "/";
  static const ROUTE_HOME = "/home";
  static const ROUTE_CONVERSATION = "/conversation";
  static const ROUTE_NEW_CONVERSATION = "/new_conversation";
  static const ROUTE_EDIT_CONVERSATION = "/edit_conversation";
  static const ROUTE_SETUP_STORY = "/setup_story";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Route result;
    switch (settings.name) {
      case ROUTE_INIT:
        result = MaterialPageRoute(builder: (_) => SplashPage());
        break;
      case ROUTE_HOME:
        result = MaterialPageRoute(builder: (_) => HomePage());
        break;
      case ROUTE_CONVERSATION:
        result = MaterialPageRoute(builder: (_) => ConversationPage(args));
        break;
      case ROUTE_NEW_CONVERSATION:
        result = MaterialPageRoute(builder: (_) => NewConversationPage());
        break;
      case ROUTE_EDIT_CONVERSATION:
        result = MaterialPageRoute(builder: (_) => EditConversationPage(args));
        break;
      case ROUTE_SETUP_STORY:
        result = MaterialPageRoute(builder: (_) => SetupStoryPage(args));
        break;
    }
    return result;
  }
}
