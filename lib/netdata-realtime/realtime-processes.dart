import 'dart:async';

import 'package:flutter/material.dart';
import '../fetchdata.dart';
import 'package:flutter_netdata/model/server.dart';

class RealTimeProcesses extends StatefulWidget {
  final Server serv;
  final int interval;

  RealTimeProcesses({this.serv, this.interval});
  @override
  RealTimeProcessesState createState() =>
      RealTimeProcessesState(serv: this.serv, interval: this.interval);
}

class RealTimeProcessesState extends State<RealTimeProcesses> {
  Future<Map<String, dynamic>> processes;
  final Server serv;
  final int interval;
  Timer _timer;

  RealTimeProcessesState({this.serv, this.interval}) {
    processes =
        fetchData(serv.protocol, serv.domain, serv.port, 'system.processes');
  }

  _generateTrace(Timer t) {
    setState(() {
      processes =
          fetchData(serv.protocol, serv.domain, serv.port, 'system.processes');
    });
  }

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: interval), _generateTrace);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: processes,
        builder: (context, snapshot) {
          List<dynamic> data = snapshot.data['data'];
          return Text(data[0][1].toString());
        });
  }
}
