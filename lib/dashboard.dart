import 'package:flutter/material.dart';
import 'package:flutter_netdata/ssh_util.dart';
import 'ssh_util.dart';
import 'server.dart';
import 'fetch-processes.dart';
import 'package:line_icons/line_icons.dart';


class Dashboard extends StatelessWidget {
  final Server serv;

  Dashboard({this.serv});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xff333366),
          appBar: AppBar(
            backgroundColor: Color(0xff353848),
            brightness: Brightness.light,
            title: Text('Server [ ' + serv.label + ' ] ' + 'Page'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(LineIcons.line_chart)),
                Tab(icon: Icon(LineIcons.keyboard_o)),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView(
                padding: EdgeInsets.all(8.0),
                children: <Widget>[
                  SizedBox(
                    height: 250.0,
                    child: FetchProcesses(
                      serv: serv,
                      interval: 1000,
                    ),
                  ),
                ],
              ),
              SSHPage(host: serv.domain, ssh_id: serv.sshid, ssh_pw: serv.pw),
            ],
          ),
        ),
      ),
    );
  }
}
