import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../fetch-processes.dart';
import '../post.dart';

class ProcessesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ProcessesChart(this.seriesList, {this.animate});

  factory ProcessesChart.withJson(Post data) {
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
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createJsonData(
      Post test) {
    List<TimeSeriesSales> data = List<TimeSeriesSales>();
    test.rowsItemList.forEach((e) {
      data.add(
          TimeSeriesSales(parseStringToDatetime(e.c[0]['v']), e.c[3]['v']));
    });

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales data, _) => data.time,
        measureFn: (TimeSeriesSales data, _) => data.data,
        data: data,
      )
    ];
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int data;

  TimeSeriesSales(this.time, this.data);
}
