import 'package:flutter/material.dart';

import 'package:servercat/ui/dashboard.dart';
import 'package:servercat/ui/edit.dart';
import 'package:servercat/ui/login.dart';
import 'package:servercat/ui/add.dart';
import 'package:servercat/ui/detail.dart';

class ServerCat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServerCat',
      home: Dashboard(),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return _buildRoute(settings, Dashboard());
      case '/login':
        return _buildRoute(settings, LoginPage());
      case '/add':
        return _buildRoute(settings, AddPage());
      case '/edit':
        return _buildRoute(settings, EditPage(serv: settings.arguments));
      case '/charts':
        return _buildRoute(
            settings,
            DetailPage(
              serv: settings.arguments,
            ));
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
