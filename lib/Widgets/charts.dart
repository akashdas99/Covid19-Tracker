import 'package:covid19_tracker/models/time_line.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  // final Function(DateTime) onItemClicked;

  SimpleTimeSeriesChart(this.seriesList);

  factory SimpleTimeSeriesChart.withData(List<Timeline> timeLine) {
    List<Confirmed> confirmed = timeLine.map((item) {
      return Confirmed(time: item.date, cases: item.confirmed);
    }).toList();

    List<Recovered> recovered = timeLine.map((item) {
      return Recovered(time: item.date, cases: item.recovered);
    }).toList();

    List<Deaths> deaths = timeLine.map((item) {
      return Deaths(time: item.date, cases: item.deaths);
    }).toList();

    var list = [
      charts.Series<Confirmed, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (Confirmed cases, _) => cases.time,
        measureFn: (Confirmed cases, _) => cases.cases,
        data: confirmed,
      ),
      charts.Series<Recovered, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Recovered cases, _) => cases.time,
        measureFn: (Recovered cases, _) => cases.cases,
        data: recovered,
      ),
      charts.Series<Deaths, DateTime>(
        id: 'Deaths',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (Deaths cases, _) => cases.time,
        measureFn: (Deaths cases, _) => cases.cases,
        data: deaths,
      )
    ];

    return SimpleTimeSeriesChart(list);
  }

  @override
  _SimpleTimeSeriesChartState createState() => _SimpleTimeSeriesChartState();
}

class _SimpleTimeSeriesChartState extends State<SimpleTimeSeriesChart> {
  DateTime _time;
  Map<String, num> _measures;

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.cases;
      });
    }

    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      SizedBox(
        height: 300.0,
        child: charts.TimeSeriesChart(
          widget.seriesList,
          // animationDuration: Duration(seconds: 2),
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          animate: true,
          selectionModels: [
            charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged)
          ],
        ),
      ),
    ];
    if (_time != null) {
      children.add(Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text(
              'Date: ${_time.day.toString()}-${_time.month.toString()}-${_time.year.toString()}',
              style: TextStyle(color: Colors.black))));
    }
    _measures?.forEach((String series, num value) {
      Color color;
      if (series == 'Confirmed') {
        color = Colors.indigo;
      }
      if (series == 'Recovered') {
        color = Colors.greenAccent[700];
      }
      if (series == 'Deaths') {
        color = Colors.grey[600];
      }
      children.add(Text(
        '$series: $value',
        style: TextStyle(
          color: color,
        ),
      ));
    });

    return Column(children: children);
  }
}

class Confirmed {
  DateTime time;
  int cases;

  Confirmed({this.time, this.cases});
}

class Recovered {
  final DateTime time;
  final int cases;

  Recovered({this.time, this.cases});
}

class Deaths {
  final DateTime time;
  final int cases;

  Deaths({this.time, this.cases});
}
