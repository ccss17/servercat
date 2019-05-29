import 'dart:async';
import 'package:flutter_netdata/netdata-charts/processes-chart.dart';

import 'package:flutter/material.dart';
import 'post.dart';
import 'server.dart';

class FetchProcesses extends StatefulWidget {
  final Server serv;

  FetchProcesses({this.serv});
  @override
  FetchProcessesState createState() => FetchProcessesState(serv: this.serv);
}

class FetchProcessesState extends State<FetchProcesses> {
  Future<Post> post;
  final Server serv;
  Timer _timer;

  FetchProcessesState({this.serv}) {
    post = fetchPost(serv.protocol, serv.domain, serv.port, 'system.processes');
  }

  _generateTrace(Timer t) {
    setState(() {
      post =
          fetchPost(serv.protocol, serv.domain, serv.port, 'system.processes');
    });
  }

  @override
  initState() {
    super.initState();
    post = fetchPost(serv.protocol, serv.domain, serv.port, 'system.processes');
    _timer = Timer.periodic(Duration(milliseconds: 3000), _generateTrace);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Post>(
        future: post,
        builder: (context, snapshot) {
          return ProcessesChart.withJson(snapshot.data);
        });
  }
}
