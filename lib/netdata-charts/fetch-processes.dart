import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../fetchdata.dart';
import '../server.dart';

class ProcessesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ProcessesChart(this.seriesList, {this.animate});

  factory ProcessesChart.withJson(Map<String, dynamic> data) {
    return ProcessesChart(
      _createJsonData(data),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        charts.ChartTitle('Processes',
            titleOutsideJustification: charts.OutsideJustification.start,
            innerPadding: 25),
      ],
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createJsonData(
      Map<String, dynamic> jsonData) {
    List<TimeSeriesSales> data = List<TimeSeriesSales>();
    int i = 0;
    for (var e in jsonData['data']) {
      i++;
      if (i == 2400) break;
      if (e[0] % 15 == 0)
        data.add(TimeSeriesSales(
            DateTime.fromMicrosecondsSinceEpoch(e[0] * 1000000), e[1]));
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (TimeSeriesSales data, _) => data.time,
        measureFn: (TimeSeriesSales data, _) => data.data,
        data: data,
      )
    ];
  }
}

class FetchProcesses extends StatefulWidget {
  final Server serv;
  final int interval;

  FetchProcesses({this.serv, this.interval});
  @override
  FetchProcessesState createState() =>
      FetchProcessesState(serv: this.serv, interval: this.interval);
}

class FetchProcessesState extends State<FetchProcesses> {
  Future<Map<String, dynamic>> post;
  final Server serv;
  final int interval;
  Timer _timer;

  FetchProcessesState({this.serv, this.interval}) {
    post = fetchData(serv.protocol, serv.domain, serv.port, 'system.processes');
  }

  _generateTrace(Timer t) {
    setState(() {
      post =
          fetchData(serv.protocol, serv.domain, serv.port, 'system.processes');
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
          return ProcessesChart.withJson(snapshot.data);
        });
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int data;

  TimeSeriesSales(this.time, this.data);
}
