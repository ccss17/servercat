import 'dart:async';

import 'package:flutter/material.dart';
import 'post.dart';
import 'server.dart';

class RealTimeProcesses extends StatefulWidget {
  final Server serv;
  final int interval;

  RealTimeProcesses({this.serv, this.interval});
  @override
  RealTimeProcessesState createState() =>
      RealTimeProcessesState(serv: this.serv, interval: this.interval);
}

class RealTimeProcessesState extends State<RealTimeProcesses> {
  Future<Post> post;
  final Server serv;
  final int interval;
  Timer _timer;

  RealTimeProcessesState({this.serv, this.interval}) {
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
          List<RowsItem> tmp = snapshot.data.rowsItemList;
          return Text(
              tmp[tmp.length - 1].c[3]['v'].toString());
        });
  }
}
