class LatestData{
  int deaths;
  int confirmed;
  int recovered;
  int critical;


  LatestData({this.deaths,this.confirmed,this.recovered,this.critical});

  factory LatestData.fromJson(Map<String,dynamic> parsedJson){
    return LatestData(
      deaths: parsedJson['deaths'],
      confirmed: parsedJson['confirmed'],
      recovered: parsedJson['recovered'],
      critical: parsedJson['critical'],
    );
  }
}