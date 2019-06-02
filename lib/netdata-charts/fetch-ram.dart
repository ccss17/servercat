import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../fetchdata.dart';
import '../server.dart';

class RAMChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  RAMChart(this.seriesList, {this.animate});

  factory RAMChart.withJson(Map<String, dynamic> data) {
    return RAMChart(
      _createJsonData(data),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(seriesList,
        defaultRenderer:
            charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: animate);
  }

  static List<charts.Series<LinearSales, DateTime>> _createJsonData(
      Map<String, dynamic> jsonData) {
    List<LinearSales> data = List<LinearSales>();
    List<LinearSales> data2 = List<LinearSales>();
    List<LinearSales> data3 = List<LinearSales>();
    List<LinearSales> data4 = List<LinearSales>();

    List<LinearSales> initData(int idx) {
      List<LinearSales> data = List<LinearSales>();
      int i = 0;
      for (var e in jsonData['data']) {
        i++;
//        if (i == 120) break;
        data.add(LinearSales(
            DateTime.fromMicrosecondsSinceEpoch(e[0] * 1000000),
            e[idx].round()));
      }
      return data;
    }

    data = initData(1);
    data2 = initData(2);
    data3 = initData(3);
    data4 = initData(4);

    return [
      charts.Series<LinearSales, DateTime>(
        id: 'buffers',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        areaColorFn: (_, __) =>
            charts.MaterialPalette.deepOrange.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      ),
      charts.Series<LinearSales, DateTime>(
        id: 'cached',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        areaColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data2,
      ),
      charts.Series<LinearSales, DateTime>(
        id: 'used',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        areaColorFn: (_, __) =>
            charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data3,
      ),
      charts.Series<LinearSales, DateTime>(
        id: 'free',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        areaColorFn: (_, __) =>
            charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data4,
      ),
    ];
  }
}

class FetchRAM extends StatefulWidget {
  final Server serv;
  final int interval;

  FetchRAM({this.serv, this.interval});
  @override
  FetchRAMState createState() =>
      FetchRAMState(serv: this.serv, interval: this.interval);
}

class FetchRAMState extends State<FetchRAM> {
  Future<Map<String, dynamic>> post;
  final Server serv;
  final int interval;
  Timer _timer;

  FetchRAMState({this.serv, this.interval}) {
    post = fetchData(serv.protocol, serv.domain, serv.port, 'system.ram');
  }

  _generateTrace(Timer t) {
    setState(() {
      post = fetchData(serv.protocol, serv.domain, serv.port, 'system.ram');
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
          return RAMChart.withJson(snapshot.data);
        });
  }
}

class LinearSales {
  final DateTime year;
  final int sales;

  LinearSales(this.year, this.sales);
}
