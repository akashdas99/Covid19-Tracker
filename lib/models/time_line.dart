class Timeline {
  int confirmed;
  int newConfirmed;
  int recovered;
  int newRecovered;
  int deaths;
  int newDeaths;

  int critical;
  DateTime date;

  Timeline(
      {this.confirmed,
      this.newConfirmed,
      this.recovered,
      this.newRecovered,
      this.deaths,
      this.newDeaths,
      this.critical,
      this.date});

  factory Timeline.fromJson(Map<String, dynamic> parsedJson) {
    return Timeline(
      confirmed: parsedJson['confirmed'],
      newConfirmed: parsedJson['new_confirmed'],
      recovered: parsedJson['recovered'],
      newRecovered: parsedJson['new_recovered'],
      deaths: parsedJson['deaths'],
      newDeaths: parsedJson['new_deaths'],
      critical: parsedJson['critical'],
      date: DateTime.parse(parsedJson['date']),
    );
  }
}
