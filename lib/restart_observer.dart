
import 'package:flutter/material.dart';
import 'main.dart';  
class RestartObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is MaterialPageRoute && previousRoute.settings.name == '/') {
      MyApp.restartApp();
    }
  }
}
