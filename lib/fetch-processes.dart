import 'dart:async';
import 'package:flutter_netdata/netdata-charts/processes-chart.dart';

import 'package:flutter/material.dart';
import 'post.dart';
import 'server.dart';

class FetchProcesses extends StatefulWidget {
  final Server serv;
  final int interval;

  FetchProcesses({this.serv, this.interval});
  @override
  FetchProcessesState createState() => FetchProcessesState(serv: this.serv, interval: this.interval);
}

class FetchProcessesState extends State<FetchProcesses> {
  Future<Post> post;
  final Server serv;
  final int interval;
  Timer _timer;

  FetchProcessesState({this.serv, this.interval}) {
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
    _timer = Timer.periodic(Duration(milliseconds: interval), _generateTrace);
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
