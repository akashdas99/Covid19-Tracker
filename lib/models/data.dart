import 'package:covid19_tracker/models/latest_data.dart';
import 'package:covid19_tracker/models/time_line.dart';

class Data {
  String name;
  String code;
  DateTime updatedAt;
  final LatestData latestData;
  final List<Timeline> timeLine;

  Data({this.name, this.code, this.updatedAt, this.latestData, this.timeLine});

  factory Data.fromJson(Map<String, dynamic> parsedJson) {
    return Data(
      name: parsedJson['name'],
      code: parsedJson['code'],
      updatedAt: parsedJson['updatedAt'],
      latestData: LatestData.fromJson(parsedJson['latest_data']),
      timeLine: parsedJson['timeline']
          .map<Timeline>((val) => Timeline.fromJson(val))
          .toList(),
    );
  }
}
