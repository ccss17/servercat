import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'add.dart';

class FlutterNetdata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      home: HomePage(),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return _buildRoute(settings, HomePage());
      case '/login':
        return _buildRoute(settings, LoginPage());
      case '/add':
        return _buildRoute(settings, AddPage());
      default:
        return null;
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => builder,
      fullscreenDialog: true,
    );
  }
}
