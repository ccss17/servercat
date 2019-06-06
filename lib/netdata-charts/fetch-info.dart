import 'dart:async';
import 'package:flutter/material.dart';
import '../fetchdata.dart';
import '../server.dart';

class ServerInfo extends StatelessWidget {
  Map<String, dynamic> data;

  ServerInfo(this.data);

  Widget _getLabels(String label) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _getInfo(String label, String data) {
    return Container(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(data),
        ],
      ),
    );
  }

  Widget _getLabelText(String label) {
    return Text(
      label,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getLabelText('OS NAME'),
            _getLabelText('OS VERSION'),
            _getLabelText(
              'KERNEL NAME',
            ),
            _getLabelText(
              'KERNEL VERSION',
            ),
            _getLabelText(
              'ARCHITECTURE',
            ),
            _getLabelText(
              'NETDATA VERSION',
            ),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(data['os_name']),
            Text(data['os_version']),
            Text(data['kernel_name']),
            Text(data['kernel_version']),
            Text(data['architecture']),
            Text(data['version']),
          ],
        ),
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
