class City {
  final int totalCases;
  final int deaths;
  final int active;
  final int recovered;
  City({this.totalCases,this.active, this.deaths, this.recovered});

  factory City.fromJSON(Map<String, dynamic> json, cityName, stateName) {
    return City(
        totalCases: json[stateName]['districtData'][cityName]['confirmed'],
        deaths: json[stateName]['districtData'][cityName]['deceased'],
        active: json[stateName]['districtData'][cityName]['active'],
        recovered: json[stateName]['districtData'][cityName]['recovered']);
  }
}