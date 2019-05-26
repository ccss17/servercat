import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_netdata/ssh_util.dart';
import 'post.dart';
import 'ssh_util.dart';
import 'server.dart';
import 'fetch-processes.dart';

class Dashboard extends StatefulWidget {
  final Server serv;

  Dashboard({this.serv});
  @override
  DashboardState createState() => DashboardState(serv: this.serv);
}

class DashboardState extends State<Dashboard> {
  Future<Post> post;
  final Server serv;
  Timer _timer;

  DashboardState({this.serv});

  _generateTrace(Timer t) {
    setState(() {
      post =
          fetchPost(serv.protocol, serv.domain, serv.port, 'system.processes');
    });
  }

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 5000), _generateTrace);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff333366),
      appBar: AppBar(
        backgroundColor: Color(0xff353848),
        brightness: Brightness.light,
        title: Text('Server Page'),
      ),
      body: Center(
        child: FutureBuilder<Post>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MaterialApp(
                home: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    SizedBox(
                      height: 250.0,
                      child: FetchProcesses(
                        serv: serv,
                      ),
                    ),
                    SSHPage(
                        host: serv.domain, ssh_id: serv.sshid, ssh_pw: serv.pw),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
