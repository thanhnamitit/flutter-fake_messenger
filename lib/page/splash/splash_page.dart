import 'package:conversation_maker/core/route_config.dart';
import 'package:conversation_maker/page/splash/splash_view_model.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void navigateToHome() {
    Navigator.of(context).pushReplacementNamed(RouteConfig.ROUTE_HOME);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var splashViewModel = SplashViewModel();
    splashViewModel.addListener(() {
      if (splashViewModel.updateSuccessful) {
        navigateToHome();
        splashViewModel.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Text(
            "Messenger",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
