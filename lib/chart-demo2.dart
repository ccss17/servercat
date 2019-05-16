import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/// Sample time series data type.
class TimeSeriesPrice {
  final DateTime time;
  final double price;

  TimeSeriesPrice(this.time, this.price);
}

class ItemDetailsPage extends StatefulWidget {
  @override
  _ItemDetailsPageState createState() => new _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  String url =
      "https://min-api.cryptocompare.com/data/histoday?fsym=BTC&tsym=USD&limit=1&aggregate=1&allData=true";

  List dataJSON;

  Future<String> getCoinsTimeSeries() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      dataJSON = extractdata["Data"];
    });
  }

  @override
  void initState() {
    this.getCoinsTimeSeries();
  }

  @override
  Widget build(BuildContext context) {
    List<TimeSeriesPrice> data = [];
    print('json:'+dataJSON.toString());
// populate data with a list of dates and prices from the json
    for (Map m in dataJSON) {
      data.add(TimeSeriesPrice(m['date'], m['price']));
    }
    // final data = [
    //   // How to apply the JSON data in TimeSeriesPrice ?
    //   new TimeSeriesPrice(new DateTime(2017, 9, 19), 5),
    //   new TimeSeriesPrice(new DateTime(2017, 9, 26), 25),
    //   new TimeSeriesPrice(new DateTime(2017, 10, 3), 100),
    //   new TimeSeriesPrice(new DateTime(2017, 10, 10), 75),
    // ];

    var series = [
      new charts.Series<TimeSeriesPrice, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesPrice price, _) => price.time,
        measureFn: (TimeSeriesPrice price, _) => price.price,
        data: data,
      )
    ];

    var chart = new charts.TimeSeriesChart(
      series,
      animate: true,
    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return Scaffold(
      appBar: new AppBar(title: new Text("Details")),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            chartWidget,
          ],
        ),
      ),
    );
  }
}
