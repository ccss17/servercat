import 'dart:async';

import 'package:flutter/material.dart';
import '../fetchdata.dart';
import '../server.dart';

class RealTimeRAM extends StatefulWidget {
  final Server serv;
  final int interval;

  RealTimeRAM({this.serv, this.interval});
  @override
  RealTimeRAMtate createState() =>
      RealTimeRAMtate(serv: this.serv, interval: this.interval);
}

class RealTimeRAMtate extends State<RealTimeRAM> {
  Future<Map<String, dynamic>> ram;
  final Server serv;
  final int interval;
  Timer _timer;

  RealTimeRAMtate({this.serv, this.interval}) {
    ram =
        fetchData(serv.protocol, serv.domain, serv.port, 'system.ram');
  }

  _generateTrace(Timer t) {
    setState(() {
      ram =
          fetchData(serv.protocol, serv.domain, serv.port, 'system.ram');
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
        future: ram,
        builder: (context, snapshot) {
          List<dynamic> data = snapshot.data['data'];
          return Text(data[data.length - 1][1].toString());
        });
  }
}
