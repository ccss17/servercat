import 'dart:async';

import 'package:flutter/material.dart';
import '../fetchdata.dart';
import '../server.dart';
import 'package:intl/intl.dart';

class RealTimeCPU extends StatefulWidget {
  final Server serv;
  final int interval;

  RealTimeCPU({this.serv, this.interval});
  @override
  RealTimeCPUState createState() =>
      RealTimeCPUState(serv: this.serv, interval: this.interval);
}

class RealTimeCPUState extends State<RealTimeCPU> {
  Future<Map<String, dynamic>> cpu;
  final Server serv;
  final int interval;
  Timer _timer;

  RealTimeCPUState({this.serv, this.interval}) {
    cpu = fetchData(serv.protocol, serv.domain, serv.port, 'system.cpu');
  }

  _generateTrace(Timer t) {
    setState(() {
      cpu = fetchData(serv.protocol, serv.domain, serv.port, 'system.cpu');
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
        future: cpu,
        builder: (context, snapshot) {
          List<dynamic> data = snapshot.data['data'];
          print(data[data.length - 1]);
          return Text(
              NumberFormat("###.##").format(data[data.length - 1][3]) + '%');
        });
  }
}
