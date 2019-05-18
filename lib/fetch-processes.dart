import 'dart:async';
import 'package:flutter_netdata/netdata-charts/processes-chart.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String split_netdata(String text) {
  var test = text.split('table')[1];
  return (test.substring(1, test.indexOf(';') - 2));
}

Future<Post> fetchPost() async {
  final response = await http.get(
      'http://54.180.132.66:19999/api/v1/data?chart=system.processes&after=-60&format=datasource&options=nonzero');
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(split_netdata(response.body)));
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  List<ColsItem> colsItemList = List<ColsItem>();
  List<RowsItem> rowsItemList = List<RowsItem>();

  Post({this.colsItemList, this.rowsItemList});

  factory Post.fromJson(Map<String, dynamic> json) {
    List<ColsItem> colsItem_tmp = List<ColsItem>();
    List<RowsItem> rowsItem_tmp = List<RowsItem>();
    json['cols'].forEach((e) {
      colsItem_tmp.add(ColsItem(
          id: e['id'],
          label: e['label'],
          pattern: e['pattern'],
          type: e['type'],
          p: e['p'] ?? null));
    });
    json['rows'].forEach((e) {
      rowsItem_tmp.add(RowsItem(c: e['c']));
    });

    return Post(colsItemList: colsItem_tmp, rowsItemList: rowsItem_tmp);
  }
}

class ColsItem {
  final String id;
  final String label;
  final String pattern;
  final String type;
  final Map<String, dynamic> p;

  ColsItem(
      {@required this.id,
      @required this.label,
      @required this.pattern,
      @required this.type,
      @required this.p});
}

class RowsItem {
  final List<dynamic> c;

  RowsItem({this.c});
}

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
      post = fetchPost();
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
