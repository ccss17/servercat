import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../fetchdata.dart';
import 'package:servercat/model/server.dart';

class CPUChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CPUChart(this.seriesList, {this.animate});

  factory CPUChart.withJson(Map<String, dynamic> data) {
    return CPUChart(
      _createJsonData(data),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      defaultRenderer:
          charts.LineRendererConfig(includeArea: true, stacked: true),
      animate: animate,
      behaviors: [
        charts.ChartTitle('CPU',
            titleOutsideJustification: charts.OutsideJustification.start,
            innerPadding: 25),
      ],
    );
  }

  static List<charts.Series<LinearSales, DateTime>> _createJsonData(
      Map<String, dynamic> jsonData) {
    List<LinearSales> data = List<LinearSales>();
    List<LinearSales> data2 = List<LinearSales>();
    List<LinearSales> data3 = List<LinearSales>();
    List<LinearSales> data4 = List<LinearSales>();
    List<LinearSales> data5 = List<LinearSales>();

    List<LinearSales> initData(int idx) {
      List<LinearSales> data = List<LinearSales>();
      int i = 0;
      for (var e in jsonData['data']) {
        i++;
        if (i == 300) break;
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
    data5 = initData(5);

    return [
      charts.Series<LinearSales, DateTime>(
        id: 'steal',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        areaColorFn: (_, __) =>
            charts.MaterialPalette.deepOrange.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      ),
      charts.Series<LinearSales, DateTime>(
        id: 'softirq',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        areaColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data2,
      ),
      charts.Series<LinearSales, DateTime>(
        id: 'user',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data3,
      ),
      charts.Series<LinearSales, DateTime>(
        id: 'system',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        areaColorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data4,
      ),
      charts.Series<LinearSales, DateTime>(
        id: 'iowait',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        areaColorFn: (_, __) =>
            charts.MaterialPalette.green.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data5,
      ),
    ];
  }
}

class FetchCPU extends StatefulWidget {
  final Server serv;
  final int interval;

  FetchCPU({this.serv, this.interval});
  @override
  FetchCPUState createState() =>
      FetchCPUState(serv: this.serv, interval: this.interval);
}

class FetchCPUState extends State<FetchCPU> {
  Future<Map<String, dynamic>> post;
  final Server serv;
  final int interval;
  Timer _timer;

  FetchCPUState({this.serv, this.interval}) {
    post = fetchData(serv.protocol, serv.domain, serv.port, 'system.cpu');
  }

  _generateTrace(Timer t) {
    setState(() {
      post = fetchData(serv.protocol, serv.domain, serv.port, 'system.cpu');
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
          return CPUChart.withJson(snapshot.data);
        });
  }
}

class LinearSales {
  final DateTime year;
  final int sales;

  LinearSales(this.year, this.sales);
}
