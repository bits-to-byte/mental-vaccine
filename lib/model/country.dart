class Country {
  final int totalCases;
  final int deaths;
  final int active;
  final int recovered;
  Country({this.totalCases, this.active, this.deaths, this.recovered});

  factory Country.fromJSON(Map<String, dynamic> json) {
    return Country(
        totalCases: json['cases'],
        deaths: json['deaths'],
        active: json['active'],
        recovered: json['recovered']);
  }
}