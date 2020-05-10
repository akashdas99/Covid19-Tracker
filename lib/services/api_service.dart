import 'dart:convert';
import 'package:covid19_tracker/models/data.dart';
import 'package:http/http.dart' as http;

Future<Data> fetchApi(String iso) async {
  final url = "http://corona-api.com/countries/";

  final res = await http.get(url + iso);
  if (res.statusCode == 200) {
    final jsonRes = jsonDecode(res.body)['data'];
    Data resp = new Data.fromJson(jsonRes);
    return resp;
  } else {
    throw Exception('Failed to fetch Data');
  }
}
