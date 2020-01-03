import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/route_config.dart';

class MyApp extends StatelessWidget {
  final List<SingleChildCloneableWidget> _providers;

  MyApp(this._providers);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Conversation maker',
        theme: ThemeData(
            canvasColor: Colors.transparent,
            fontFamily: "Mono",
            primarySwatch: Colors.blue,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            })),
        initialRoute: RouteConfig.ROUTE_INIT,
        onGenerateRoute: RouteConfig.generateRoute,
      ),
    );
  }
}
