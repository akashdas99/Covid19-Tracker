import 'package:covid19_tracker/models/data.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  const Details({
    Key key,
    @required Data res,
  })  : _res = res,
        super(key: key);

  final Data _res;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 18.0,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Overall Cases",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.0),
        Text(
          "Total confirmed cases: ${_res.latestData.confirmed.toString()}",
          style: textStyle.copyWith(color: Colors.indigo),
        ),
        SizedBox(height: 4.0),
        Text(
          "Recovered: ${_res.latestData.recovered.toString()}",
          style: textStyle.copyWith(color: Colors.greenAccent[700]),
        ),
        SizedBox(height: 4.0),
        Text(
          "Critical cases: ${_res.latestData.critical.toString()}",
          style: textStyle.copyWith(color: Colors.red[300]),
        ),
        SizedBox(height: 4.0),
        Text(
          "Deaths: ${_res.latestData.deaths.toString()}",
          style: textStyle.copyWith(color: Colors.grey[600]),
        ),
        Divider(
          height: 28.0,
          thickness: 2.0,
        ),
        Text(
          "Today's Cases",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.0),
        Text(
          "Total confirmed cases: ${_res.timeLine[0].newConfirmed.toString()}",
          style: textStyle.copyWith(color: Colors.indigo),
        ),
        SizedBox(height: 4.0),
        Text(
          "Recovered: ${_res.timeLine[0].newRecovered.toString()}",
          style: textStyle.copyWith(color: Colors.greenAccent[700]),
        ),
        SizedBox(height: 4.0),
        Text(
          "Deaths: ${_res.timeLine[0].newDeaths.toString()}",
          style: textStyle.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
