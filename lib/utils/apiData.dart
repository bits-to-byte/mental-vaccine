import 'dart:convert';

import 'package:covid_help/model/city.dart';
import 'package:covid_help/model/country.dart';
import 'package:http/http.dart' as http;

class APIData {

  Future<Country> getCase() async {
    String url = 'https://corona.lmao.ninja/v2/countries/India?yesterday=true&strict=true&query';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Country.fromJSON(json.decode(response.body));
    } else {
      throw Exception("Failed to load Post");
    }
  }

  Future<City> getHomeCase(cityName, stateName) async {
    String url =
        'https://api.covid19india.org/state_district_wise.json';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return City.fromJSON(json.decode(response.body), cityName, stateName);
    } else {
      throw Exception("Failed to load Post");
    }
  }
/*
  Future<CountryDataList> getCountryData() async {
    String url = 'https://coronavirus-19-api.herokuapp.com/countries';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonRes = json.decode(response.body);
      return CountryDataList.fromJson(jsonRes);
    } else {
      throw Exception("Failed due to Network Error");
    }
  }*/
}