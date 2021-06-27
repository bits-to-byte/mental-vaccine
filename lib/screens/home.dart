import 'package:covid_help/animations/bottom.dart';
import 'package:covid_help/components/listTile.dart';
import 'package:covid_help/model/city.dart';
import 'package:covid_help/model/country.dart';
import 'package:covid_help/screens/SpeechScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:covid_help/utils/apiData.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final fb = FirebaseDatabase.instance;
  Position _currentPosition;
  String _currentCity;
  String _currentState;
  String _currentLocality;
  int totalCaseCount;
  int active;
  int deathCount;
  int recoveredCount;

  void _getStats(int totalCaseCount, int active, int deathCount, int recoveredCount) {
    this.totalCaseCount = totalCaseCount;
    this.active = active;
    this.deathCount = deathCount;
    this.recoveredCount = recoveredCount;
  }
  _getCurrentLocation() {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<String> _getAddressFromLatLng() async {
    //_getCurrentLocation();
    try {
      List<geo.Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      geo.Placemark place = placemarks[0];
      setState(() {
        _currentCity = "${place.locality}";
        _currentLocality = "${place.subLocality}";
        _currentState = "${place.administrativeArea}";
      });
    } catch (e) {
      print(e);
    }
    return _currentState;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.001, horizontal: width * 0.02),
      width: width,
      height: height * 2.0,
      child: ListView(
        children: <Widget>[
          Text(
            "\tIndia Statistics",
            style: TextStyle(
                fontSize: height * 0.04,
                fontWeight: FontWeight.bold,
                fontFamily: 'MyFont'),
          ),
          GlobalDataList(),
          Text(
            "\tYou are in: " +
                _currentLocality.toString() +
                ", " +
                _currentCity.toString() +
                ", " +
                _currentState.toString(),
            style: TextStyle(
                fontSize: height * 0.03,
                fontWeight: FontWeight.w600,
                fontFamily: 'MyFont'),
          ),
          CityDataList(
              city: _currentCity, state: _currentState, locality: _currentCity),

        ],
      ),
    );
  }
}

class GlobalDataList extends StatelessWidget {
  final formatter = NumberFormat("###,###");

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: height * 0.07,
      child: FutureBuilder<Country>(
        future: APIData().getCase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int totalCaseCount = snapshot.data.totalCases;
            int active = snapshot.data.active;
            int deathCount = snapshot.data.deaths;
            int recoveredCount = snapshot.data.recovered;

            return Container(
              height: height * 0.3,
              width: width * 0.95,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      WidgetAnimator(
                        CountryListTile(
                          caseCount: totalCaseCount,
                          infoHeader: 'Cases',
                          tileColor: Colors.redAccent.withAlpha(200),
                        ),
                      ),
                      WidgetAnimator(
                        CountryListTile(
                          caseCount: active,
                          infoHeader: 'Active',
                          tileColor: Colors.blueAccent.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    WidgetAnimator(
                      CountryListTile(
                        caseCount: recoveredCount,
                        infoHeader: 'Recoveries',
                        tileColor: Colors.green.withAlpha(200),
                      ),
                    ),
                    WidgetAnimator(
                      CountryListTile(
                        caseCount: deathCount,
                        infoHeader: 'Deaths',
                        tileColor: Colors.blueGrey.withAlpha(200),
                      ),
                    ),
                  ]),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
                width: width,
                height: height * 0.2,
                child: Center(child: Text("${snapshot.error}")));
          }
          return Container(
            width: width,
            height: height * 0.2,
            child: Center(
              child: Text('Stay Home, Stay Safe!',
                  style: TextStyle(
                      fontFamily: 'MyFont', fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}

class CityDataList extends StatelessWidget {
  //var formatter = NumberFormat("###,###");
  final String city;
  final String locality;
  final String state;

  const CityDataList({this.city, this.locality, this.state, Key key});

  int _getTotal(int totalCaseCount, int active, int deathCount, int recoveredCount) {
    return totalCaseCount;
    //this.active = active;
   // this.deathCount = deathCount;
    //this.recoveredCount = recoveredCount;
  }
  int _getactive(int totalCaseCount, int active, int deathCount, int recoveredCount) {
    //return totalCaseCount;
    return active;
  }

  //const CityDataList({Key key, this.city, this.locality, this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FirebaseDatabase fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: height * 0.07,
      child: FutureBuilder<City>(
        future: APIData().getHomeCase(city, state),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int totalCaseCount = snapshot.data.totalCases;
            int active = snapshot.data.active;
            int deathCount = snapshot.data.deaths;
            int recoveredCount = snapshot.data.recovered;
            ref.child("Name - ").set("Shashank");
            ref.child("Your Location - ").set(city+ " " + state);
            ref.child("Total Confirmed case - ").set(totalCaseCount.toString());
            ref.child("Total Active cases - ").set(active.toString());
            ref.child("Total Recovered cases - ").set(recoveredCount.toString());
            ref.child("Total Deaths - ").set(deathCount.toString());

            return Container(
              height: height * 0.5,
              width: width * 0.95,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      WidgetAnimator(
                        CountryListTile(
                          caseCount: totalCaseCount,
                          infoHeader: 'Cases',
                          tileColor: Colors.redAccent.withAlpha(200),
                        ),
                      ),
                      WidgetAnimator(
                        CountryListTile(
                          caseCount: active,
                          infoHeader: 'Active',
                          tileColor: Colors.blueAccent.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    WidgetAnimator(
                      CountryListTile(
                        caseCount: recoveredCount,
                        infoHeader: 'Recoveries',
                        tileColor: Colors.green.withAlpha(200),
                      ),
                    ),
                    WidgetAnimator(
                      CountryListTile(
                        caseCount: deathCount,
                        infoHeader: 'Deaths',
                        tileColor: Colors.blueGrey.withAlpha(200),
                      ),
                    ),
                  ]),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 1.0),
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        child: ButtonTheme(
                          minWidth: 150,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.black)),
                            onPressed: () {

                              ref.child("Your Location - ").set(city+" "+ state);
                              ref.child("Total Confirmed case - ").set(totalCaseCount.toString());
                              ref.child("Total Active cases - ").set(active.toString());
                              ref.child("Total Recovered cases - ").set(recoveredCount.toString());
                              ref.child("Total Deaths - ").set(deathCount.toString());
                            },
                            color: Colors.white,
                            textColor: Colors.black,
                            child: Text("Sync",
                                style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 1.0),
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        child: ButtonTheme(
                          minWidth: 150,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.black)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SpeechScreen()),
                              );
                            },
                            color: Colors.black,
                            textColor: Colors.white,
                            child: Text("Resources",
                                style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
                width: width,
                height: height * 0.2,
                child: Center(child: Text("${snapshot.error}")));
          }
          return Container(
            width: width,
            height: height * 0.2,
            child: Center(
              child: Text('Stay Home, Stay Safe!',
                  style: TextStyle(
                      fontFamily: 'MyFont', fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
