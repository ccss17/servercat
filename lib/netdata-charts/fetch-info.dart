import 'dart:async';
import 'package:flutter/material.dart';
import '../fetchdata.dart';
import '../server.dart';

class ServerInfo extends StatelessWidget {
  Map<String, dynamic> data;

  ServerInfo(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(data['version']),
        Text(data['os_name']),
        Text(data['os_version']),
        Text(data['kernel_name']),
        Text(data['kernel_version']),
        Text(data['architecture']),
      ],
    );
  }
}

class FetchServerInfo extends StatefulWidget {
  final Server serv;
  final int interval;

  FetchServerInfo({this.serv, this.interval});
  @override
  FetchServerInfoState createState() =>
      FetchServerInfoState(serv: this.serv, interval: this.interval);
}

class FetchServerInfoState extends State<FetchServerInfo> {
  Future<Map<String, dynamic>> post;
  final Server serv;
  final int interval;
  Timer _timer;

  FetchServerInfoState({this.serv, this.interval}) {
    post = fetchData(serv.protocol, serv.domain, serv.port, 'xxx',
        fetchURL: '/api/v1/info');
  }

  _generateTrace(Timer t) {
    setState(() {
      post = fetchData(serv.protocol, serv.domain, serv.port, 'xxx',
          fetchURL: '/api/v1/info');
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
        future: post,
        builder: (context, snapshot) {
          return ServerInfo(snapshot.data);
        });
  }
}
