import 'dart:async';
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
  final List<dynamic> cols;
  final List<dynamic> rows;
  static List<ColsItem> colsItem = List<ColsItem>();
  static List<RowsItem> rowsItem = List<RowsItem>();

  Post({this.cols, this.rows});

  factory Post.fromJson(Map<String, dynamic> json) {
    json['cols'].forEach((e) {
      colsItem.add(ColsItem(
          id: e['id'],
          label: e['label'],
          pattern: e['pattern'],
          type: e['type'],
          p: e['p'] ?? null));
    });
    json['rows'].forEach((e) {
      rowsItem.add(RowsItem(c: e['c']));
    });

    // colsItem.forEach((e) => print(e.p.toString()));
    // rowsItem.forEach((e) => print(e.c.toString()));

    return Post(
      cols: json['cols'],
      rows: json['rows'],
    );
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

class FetchJsonTest extends StatelessWidget {
  final Future<Post> post;

  FetchJsonTest({Key key, this.post}) : super(key: key);

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
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.cols.toString());
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
