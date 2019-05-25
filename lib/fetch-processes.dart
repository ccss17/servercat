import 'dart:async';
import 'package:flutter_netdata/netdata-charts/processes-chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_netdata/ssh_util.dart';
import 'post.dart';
import 'ssh_util.dart';

class FetchProcesses extends StatefulWidget {
  final Future<Post> post;

  FetchProcesses({this.post});
  @override
  FetchProcessesState createState() => FetchProcessesState(post: this.post);
}

class FetchProcessesState extends State<FetchProcesses> {
  Future<Post> post;
  Timer _timer;

  FetchProcessesState({this.post});

  _generateTrace(Timer t) {
    setState(() {
      post = fetchPost('system.processes');
    });
  }

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 2000), _generateTrace);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MaterialApp(
//        theme: defaultConfig.theme,
//        showPerformanceOverlay: _showPerformanceOverlay,
                  home: ListView(
                    padding: EdgeInsets.all(8.0),
                    children: <Widget>[
                      SizedBox(
                        height: 250.0,
                        child: ProcessesChart.withJson(snapshot.data),
                      ),
                      SSHDemo(
                          host: '54.180.132.66',
                          ssh_id: 'ubuntu',
                          ssh_pw: 'ekfkawnl33')
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
      ),
    );
  }
}
