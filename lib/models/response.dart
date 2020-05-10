import 'package:covid19_tracker/models/data.dart';

class ParsedData {
  final Data data;

  ParsedData({this.data});

  factory ParsedData.fromJson(Map<String, dynamic> parsedJson) {
    return ParsedData(
      data: Data.fromJson(
        parsedJson['data'],
      ),
    );
  }
}
