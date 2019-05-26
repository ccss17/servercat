import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

DateTime parseStringToDatetime(String text) {
  var time = text.split('(')[1].split(')')[0].split(',');
  var str = '';
  time.forEach((e) {
    if (e.length == 1) {
      e = '0' + e;
    }
    str += e;
  });
  return DateTime.parse(str.substring(0, 8) + 'T' + str.substring(8));
}

String split_netdata(String text) {
  var test = text.split('table')[1];
  return (test.substring(1, test.indexOf(';') - 2));
}

Future<Post> fetchPost(List<String> args) async {
  String retriveURL = args[0] +
      '://' +
      args[1] +
      ':' +
      args[2] +
      '/api/v1/data?after=-60&format=datasource&options=nonzero&chart=' +
      args[3]; //collector;
  final response = await http.get(retriveURL);
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(split_netdata(response.body)));
  } else {
    throw Exception('Failed to load post');
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
